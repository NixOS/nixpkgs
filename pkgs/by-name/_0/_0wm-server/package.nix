{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  makeWrapper,
  writableTmpDirAsHomeHook,

  # dependencies
  ocamlPackages,
  libpng,

  # passthru
  callPackage,
  nix-update-script,
}:

let
  # TODO: remove when irmin>3.11.0
  ocamlPackages' = ocamlPackages.overrideScope (
    final: prev: {
      irmin = prev.irmin.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          # 0WM uses branch names like "scans/<uuid>", but Irmin 3.11.0 rejects '/'
          (fetchpatch2 {
            name = "add-slash-to-allowed-branch-characters.patch";
            url = "https://github.com/mirage/irmin/commit/4998815cbc7b6e93bb80fac855da87764e8e3c99.patch?full_index=1";
            hash = "sha256-OxDS1UBDLecuAYSuSHEwyXwc8bJ6QZRqZVEBn2rfz54=";
          })
        ];
      });
    }
  );
in

ocamlPackages'.buildDunePackage (finalAttrs: {
  pname = "0wm-server";
  version = "0-unstable-2026-09-24";
  strictDeps = true;
  __structuredAttrs = true;

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "lab0-cc";
    repo = "0WM-Server";
    rev = "aaf0895c210b77e53dd51ef1d8ae6543cd539c9a";
    hash = "sha256-5CG5kTKNCrlh0i9/Ep1AChNR0U/ytDffQSajc053S0s=";
  };

  nativeBuildInputs = [
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libpng
  ]
  ++ (with ocamlPackages'; [
    base64
    camlimages
    cmdliner
    domainslib
    dream
    ezjsonm
    gendarme-csv
    gendarme-ezjsonm
    gendarme-toml
    gendarme-yaml
    irmin-git
    lwt_ppx
    ppx_marshal
    uuidm
  ]);

  postBuild = ''
    dune build src/zwm{,d}.exe
  '';

  postInstall = ''
    mkdir -p $out/{bin,share/0wm}

    cp -r _build/default/src/zwm.exe $out/bin/0wm
    cp -r _build/default/src/zwmd.exe $out/bin/0wmd

    cp -r static swagger $out/share/0wm
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--version-regex=(0-unstable-.*)"
        "--subpackage=mock-ap"
      ];
    };
    ap-mock = callPackage ./ap-mock-server.nix { };
  };

  meta = {
    description = "0WM Server";
    homepage = "https://github.com/lab0-cc/0WM-Server";
    mainProgram = "0wmd";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
