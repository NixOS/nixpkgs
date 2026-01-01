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
<<<<<<< HEAD
  version = "1.3.21";
=======
  version = "1.3.20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "michaelb";
    repo = "sniprun";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-L/OTi6vHyfcvlVgpgjiU3MBCd6v00GKlAkUwBm4X500=";
=======
    hash = "sha256-z8viNr1TBGfWqgjfZKYJTEa1/KytKBmLbqcQrAiTZyc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  sniprun-bin = rustPlatform.buildRustPackage {
    pname = "sniprun-bin";
    inherit version src;

<<<<<<< HEAD
    cargoHash = "sha256-6xh4YyXGIqrU9ixQ6QDCGDtaROoPe8iSMlytclbqqtY=";
=======
    cargoHash = "sha256-Ki1IFQzG4rOakGX5HsYWL8GeQ53dN7WAIZ113+bwcvI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
