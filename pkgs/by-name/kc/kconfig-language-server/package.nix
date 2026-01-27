{
  lib,
  stdenv,
  fetchFromGitHub,
  gawk,
  gnused,
  jq,
  ripgrep,
}:

stdenv.mkDerivation rec {
  pname = "kconfig-language-server";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "anakin4747";
    repo = pname;
    rev = version;
    sha256 = "sha256-c6GeIRMyXUkJ/Mffq0wM6ARVP3fLQdVLVVCvaLiqpqg=";
  };

  propagatedBuildInputs = [
    gawk
    gnused
    jq
    ripgrep
  ];

  dontBuild = true;

  installPhase = ''
    make install DESTDIR=$out PREFIX=
  '';

  meta = with lib; {
    description = "Language server for the Kernel configuration language used in Linux, U-boot, Zephyr, and coreboot";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.anakin4747 ];
    mainProgram = pname;
  };
}
