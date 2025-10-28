{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
}:

stdenv.mkDerivation {
  pname = "bean-add";
  version = "unstable-2018-01-08";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "660c657f295b019d8dbc26375924eb17bf654341";
    sha256 = "0vzff2hdng8ybwd5frflhxpak0yqg0985p1dy7vpvhr8kbqqzwdz";
  };

  propagatedBuildInputs = with python3Packages; [ python ];

  installPhase = ''
    mkdir -p $out/bin/
    cp bean-add $out/bin/bean-add
    chmod +x $out/bin/bean-add
  '';

  meta = {
    homepage = "https://github.com/simon-v/bean-add/";
    description = "Beancount transaction entry assistant";
    mainProgram = "bean-add";

    # The (only) source file states:
    #   License: "Do what you feel is right, but don't be a jerk" public license.

    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
