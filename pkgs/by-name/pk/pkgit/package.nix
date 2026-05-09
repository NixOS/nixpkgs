{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  git,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:

buildNimPackage (finalAttrs: {
  pname = "pkgit";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "dacctal";
    repo = "pkgit";
    tag = "${finalAttrs.version}";
    hash = "sha256-k9egbZD7V2EdIQRTJ8kVic7pNvAvIln5O+ke1lciCT8=";
  };

  __structuredAttrs = true;

  lockFile = ./lock.json;

  # getAppFilename() returns .pkgit-wrapped after wrapProgram renames the binary,
  # breaking ensureSu's sudo re-exec. paramStr(0) gives the full wrapper path.
  postPatch = ''
    substituteInPlace src/ensureSu.nim \
      --replace-fail 'getAppFilename().extractFileName' 'paramStr(0)'
  '';

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/pkgit \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  doCheck = true;

  nativeCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unconventional package manager that compiles and installs packages directly from Git repositories";
    homepage = "https://github.com/dacctal/pkgit";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Ra77a3l3-jar ];
    mainProgram = "pkgit";
    platforms = lib.platforms.unix;
  };
})
