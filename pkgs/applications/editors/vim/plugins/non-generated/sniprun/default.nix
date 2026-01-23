{
  lib,
  fetchFromGitHub,

  # sniprun-bin
  rustPlatform,
  makeWrapper,
  bashInteractive,
  coreutils,
  curl,
  gnugrep,
  gnused,
  procps,

  # sniprun
  vimUtils,
  replaceVars,
  nix-update-script,
}:
let
  version = "1.3.21";
  src = fetchFromGitHub {
    owner = "michaelb";
    repo = "sniprun";
    tag = "v${version}";
    hash = "sha256-L/OTi6vHyfcvlVgpgjiU3MBCd6v00GKlAkUwBm4X500=";
  };
  sniprun-bin = rustPlatform.buildRustPackage {
    pname = "sniprun-bin";
    inherit version src;

    cargoHash = "sha256-6xh4YyXGIqrU9ixQ6QDCGDtaROoPe8iSMlytclbqqtY=";

    nativeBuildInputs = [ makeWrapper ];

    postInstall = ''
      wrapProgram $out/bin/sniprun \
        --prefix PATH ${
          lib.makeBinPath [
            bashInteractive
            coreutils
            curl
            gnugrep
            gnused
            procps
          ]
        }
    '';

    doCheck = false;

    meta.mainProgram = "sniprun";
  };
in
vimUtils.buildVimPlugin {
  pname = "sniprun";
  inherit version src;

  patches = [
    (replaceVars ./fix-paths.patch {
      sniprun = lib.getExe sniprun-bin;
    })
  ];

  propagatedBuildInputs = [ sniprun-bin ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.sniprun.sniprun-bin";
    };

    # needed for the update script
    inherit sniprun-bin;
  };

  meta = {
    homepage = "https://github.com/michaelb/sniprun/";
    changelog = "https://github.com/michaelb/sniprun/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ GaetanLepage ];
    license = lib.licenses.mit;
  };
}
