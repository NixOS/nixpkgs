{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-autocomplete-all-the-things";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Vifon";
    repo = "autocomplete-ALL-the-things";
    rev = version;
    sha256 = "06xd59c6gd9rglwq4km93n2p078k7v4x300lqrg1f32vvnjvs7sr";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp autocomplete-ALL-the-things $out/lib/urxvt/perl
  '';

  meta = with lib; {
    description = "urxvt plugin allowing user to easily complete arbitrary text";
    homepage = "https://github.com/Vifon/autocomplete-ALL-the-things";
    license = licenses.gpl3;
    maintainers = with maintainers; [ nickhu ];
    platforms = with platforms; unix;
  };
}
