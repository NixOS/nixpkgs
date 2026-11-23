{
  lib,
  ocamlPackages,
  fetchFromGitHub,
  versionCheckHook,

  curl,
  runCommand,

  nix-update-script,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "slipshow";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "panglesd";
    repo = "slipshow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BkGxclOb8QcLQCsGdBR+lPuuPcawTRb/RmQvDdsBSjs=";
  };

  postPatch = ''
    substituteInPlace ./src/version/slipshow_version.ml \
      --replace-fail '%%VERSION%%' '${finalAttrs.version}'
  '';

  nativeBuildInputs = with ocamlPackages; [
    js_of_ocaml
  ];

  buildInputs = with ocamlPackages; [
    ansi
    base64
    bos
    cmdliner
    dream
    fmt
    fpath
    grace
    js_of_ocaml-lwt
    linol
    linol-lwt
    logs
    lwt
    magic-mime
    ppx_blob
    ppx_deriving_yojson
    ppx_sexp_conv
    sexplib
  ];

  doCheck = true;

  nativeCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    sampleSlides = fetchFromGitHub {
      owner = "meithecatte";
      repo = "bbslides";
      rev = "ce1c08cafa71ae36dda8cc581956548b8386ae16";
      hash = "sha256-Y8wEM7MNk7R5ngb1fvFQpy7R0Ezlj/a2E/cwDOqOOvw=";
      postFetch = ''
        sed -i \
          -e '1s|<script src="drawTM.js"></script>|---\njs: drawTM.js\n---|' \
          -e 's|<img src="bbchallenge_logo.svg">|![](bbchallenge_logo.svg)|' \
          $out/bbslides.md
      '';
    };
    tests.compile =
      runCommand "slipshow-test-compile"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          slipshow compile ${finalAttrs.passthru.sampleSlides}/bbslides.md -o $out
          grep -F "The Busy Beaver Challenge" $out
        '';
    tests.serve =
      runCommand "slipshow-test-serve"
        {
          nativeBuildInputs = [
            curl
            finalAttrs.finalPackage
          ];
          __darwinAllowLocalNetworking = true;
        }
        ''
          cp -r ${finalAttrs.passthru.sampleSlides} sample
          chmod +w -R sample

          slipshow serve -p 1984 sample/bbslides.md &>/dev/null &
          server_pid=$!
          trap 'kill $server_pid 2>/dev/null || true' EXIT

          curl -sf --retry 30 --retry-delay 1 --retry-connrefused -m 30 http://localhost:1984 | grep slipshow > /dev/null
          touch $out
        '';
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/panglesd/slipshow/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Engine for displaying slips, the next-gen version of slides";
    downloadPage = "https://github.com/panglesd/slipshow";
    homepage = "https://slipshow.readthedocs.io/en/latest/index.html";
    license = lib.licenses.gpl3Only;
    mainProgram = "slipshow";
    maintainers = [ lib.maintainers.ethancedwards8 ];
    teams = [ lib.teams.ngi ];
  };
})
