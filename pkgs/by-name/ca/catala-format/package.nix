{
  lib,
  fetchFromGitHub,
  installShellFiles,

  # OCaml packages
  ocamlPackages,

  # Other dependencies
  topiary,
}:

let
  buildDunePackage = ocamlPackages.buildDunePackage;
in

buildDunePackage rec {
  pname = "catala-format";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CatalaLang";
    repo = "catala-format";
    tag = version;
    sha256 = "sha256-3LbJCwIggLzsA5Cr4UcHIomxG9J5cTdBhkaJPGqZO1k=";
  };

  doCheck = true;

  buildInputs = with ocamlPackages; [
    re
    cmdliner
    lwt
    topiary
  ];

  checkInputs = with ocamlPackages; [
    lwt
  ];

  postInstall = ''
    install -Dm444 catala.scm -t $out/share/queries
    install -Dm444 catala.ncl -t $out/share/configs
  '';

  env.TOPIARY_CONFIG_FILE = "${placeholder "out"}/share/configs/catala.ncl";
  env.TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/queries";

  meta = {
    description = "Catala Code Formatting tool";
    homepage = "https://catala-lang.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mrdev023
      jk
    ];
  };
}
