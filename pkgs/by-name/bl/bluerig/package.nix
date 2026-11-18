{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  glib,
  json-glib,
  slang,
  gpm,
  lua5_4,
  libpq,
  aspell,
  check,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluerig";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/blue-panels/bluerig/releases/download/bluerig-${finalAttrs.version}/bluerig-${finalAttrs.version}.tar.gz";
    hash = "sha256-zlBtgLimj8QejeIoeT3uYaUhoBYLdUbysdeDMoHtMeo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # These libraries are loaded with g_module_open rather than linked.
  postPatch = ''
    substituteInPlace src/plugins/query/query-pq.c \
      --replace-fail '"libpq.so.5"' '"${lib.getLib libpq}/lib/libpq${stdenv.hostPlatform.extensions.sharedLibrary}"'
    substituteInPlace src/plugins/spell/spell.c \
      --replace-fail '"libaspell"' '"${lib.getLib aspell}/lib/libaspell${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
  ];

  buildInputs = [
    glib
    json-glib
    slang
    lua5_4
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ gpm ];

  checkInputs = [ check ];

  mesonFlags = [
    (lib.mesonOption "screen" "slang")
    (lib.mesonEnable "gpm" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "lua" true)
    (lib.mesonEnable "spell" true)
    (lib.mesonEnable "nls" true)
    (lib.mesonEnable "x11" false)
    (lib.mesonEnable "tests" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=bluerig-(.*)" ];
  };

  meta = {
    description = "Terminal IDE, a continuation of cooledit";
    homepage = "https://github.com/blue-panels/bluerig";
    changelog = "https://github.com/blue-panels/bluerig/blob/bluerig-${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl3Plus
      lgpl21Plus
      lgpl3Plus
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ ilia-maslakov ];
    mainProgram = "bluerig";
    platforms = lib.platforms.unix;
  };
})
