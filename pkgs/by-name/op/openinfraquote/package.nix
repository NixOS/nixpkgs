{
  lib,
  stdenv,
  fetchFromGitHub,
  opam-installer,
  ocamlPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openinfraquote";
  version = "v1.10.0";

  src = fetchFromGitHub {
    owner = "terrateamio";
    repo = "openinfraquote";
    rev = finalAttrs.version;
    sha256 = "sha256-E0n7034XmQH1hmNy2XUKJtc0M5w6A6z+5BHlcurN8vo=";
  };

  buildInputs = with ocamlPackages; [
    yojson
    opam-file-format
    cmdliner
  ];

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    opam-installer
  ];

  meta = with lib; {
    platforms = platforms.all;
    description = "Fast, open-source tool for estimating infrastructure costs from Terraform plans and state files";
    mainProgram = "openinfraquote";
    maintainers = with maintainers; [ mtrsk ];
    license = licenses.mpl20;
    homepage = "https://openinfraquote.readthedocs.io/en/latest/";
  };
})
