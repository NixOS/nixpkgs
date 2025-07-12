{
  lib,
  stdenv,
  fetchFromGitHub,
  lv2,
}:

stdenv.mkDerivation {
  version = "1.1.3";
  pname = "plujain-ramp";

  src = fetchFromGitHub {
    owner = "Houston4444";
    repo = "plujain-ramp";
    rev = "1bc1fed211e140c7330d6035122234afe78e5257";
    sha256 = "1k7qpr8c15d623c4zqxwdklp98amildh03cqsnqq5ia9ba8z3016";
  };

  buildInputs = [
    lv2
  ];

  installFlags = [ "INSTALL_PATH=$(out)/lib/lv2" ];

  meta = with lib; {
    description = "Mono rhythmic tremolo LV2 Audio Plugin";
    homepage = "https://github.com/Houston4444/plujain-ramp";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.hirenashah ];
  };
}
