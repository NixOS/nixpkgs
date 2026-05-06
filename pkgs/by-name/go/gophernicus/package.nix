{
  lib,
  stdenv,
  fetchFromGitHub,
  gnused,
  systemdMinimal,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemdMinimal,
  nix-update-script,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gophernicus";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "gophernicus";
    repo = "gophernicus";
    tag = finalAttrs.version;
    hash = "sha256-pweiUiMmLXiyF9NMxvcWfJPH6JiGRlpT4chJiRGh9vg=";
  };

  postPatch = ''
    substituteInPlace README.md \
      --replace-warn 'DEVEL' '${finalAttrs.version}'

    substituteInPlace src/gophernicus.h \
      --replace-fail 'SAFE_PATH    "/usr/bin:/bin"' 'SAFE_PATH    "/usr/bin:/bin:/run/gophernicus/bin"'

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -E -i '/^\s+(chown|chmod)/d' Makefile.in
  '';

  configureFlags = [
    "--prefix=/"
    "--gopherroot=/share/gophernicus/gopher"
  ]
  ++ (lib.optionals systemdSupport) [
    "--listener=systemd"
  ]
  ++ (lib.optionals stdenv.hostPlatform.isDarwin) [
    "--listener=mac"
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
  ];

  preInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out"/Library/LaunchDaemons
  '';

  installTargets = [
    "install"
  ]
  ++ lib.optionals systemdSupport [
    "install-systemd"
  ];

  postInstall = lib.optionalString systemdSupport ''
    sed -i '/User=nobody/d' "$out"/lib/systemd/system/gophernicus@.service
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.gophernicus;
  };

  meta = {
    description = "Modern full-featured (and hopefully) secure gopher daemon";
    homepage = "https://gophernicus.org/";
    changelog = "https://github.com/gophernicus/gophernicus/blob/${finalAttrs.src.tag}/changelog";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ lib.maintainers.h7x4 ];
    mainProgram = "gophernicus";
  };
})
