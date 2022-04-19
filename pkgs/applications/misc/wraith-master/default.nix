{ stdenv
, lib
, fetchFromGitLab
, gtk3
, libusb1
, gradle
, jdk
, kotlin
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "wraith-master";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "serebit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zuvNR9yTFqBPTN58jN63Iv0bkc6M6yZwTGOjWdnYaRk=";
  };

  nativeBuildInputs = [
    scdoc
    gradle
  ];

  buildInputs = [
    gtk3
    jdk
    kotlin
    libusb1
  ];

  postPatch = ''
    substituteInPlace Makefile --replace ./gradlew gradle
  '';

  meta = with lib; {
    description = "A Wraith Prism RGB control application for Linux, built with GTK+ and Kotlin/Native";
    homepage = "https://gitlab.com/serebit/wraith-master";
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = with maintainers; [ papojari ];
  };
}

