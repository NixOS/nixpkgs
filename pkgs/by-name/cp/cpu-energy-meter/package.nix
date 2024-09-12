{ lib
, stdenv
, fetchFromGitHub
, libcap
}:
stdenv.mkDerivation rec {
  pname = "cpu-energy-meter";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "sosy-lab";
    repo = "cpu-energy-meter";
    rev = version;
    hash = "sha256-QW65Z8mRYLHcyLeOtNAHjwPNWAUP214wqIYclK+whFw=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "DESTDIR :=" "DESTDIR := $out" \
      --replace "PREFIX := /usr/local" "PREFIX :="
  '';

  buildInputs = [ libcap ];

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postInstall = ''
    install -Dm444 -t $out/etc/udev/rules.d $src/debian/additional_files/59-msr.rules
  '';

  meta = with lib; {
    description = "Tool for measuring energy consumption of Intel CPUs";
    homepage = "https://github.com/sosy-lab/cpu-energy-meter";
    changelog = "https://github.com/sosy-lab/cpu-energy-meter/blob/main/CHANGELOG.md";
    maintainers = with maintainers; [ lorenzleutgeb ];
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cpu-energy-meter";
  };
}
