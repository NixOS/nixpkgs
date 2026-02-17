{
  lib,
  stdenv,
  fetchFromGitHub,
  smlnj,
}:

stdenv.mkDerivation {
  pname = "celf";
  version = "2.9.3-unstable-2013-07-25";

  src = fetchFromGitHub {
    owner = "clf";
    repo = "celf";
    rev = "d61d95900ab316468ae850fa34a2fe9488bc5b59";
    sha256 = "0slrwcxglp0sdbp6wr65cdkl5wcap2i0fqxbwqfi1q3cpb6ph6hq";
  };

  buildInputs = [ smlnj ];

  # (can also build with MLton)
  buildPhase = ''
    export SMLNJ_HOME=${smlnj}
    sml < main-export.sml
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp .heap* $out/bin/
    ./.mkexec ${smlnj}/bin/sml $out/bin celf
  '';

  meta = {
    description = "Linear logic programming system";
    mainProgram = "celf";
    homepage = "https://github.com/clf/celf";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = lib.platforms.unix;
  };
}
