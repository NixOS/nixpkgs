{
  lib,
  stdenv,
  fetchurl,
  openssl,
  getconf,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "scrypt";
  version = "1.3.2";

  src = fetchurl {
    url = "https://www.tarsnap.com/scrypt/${pname}-${version}.tgz";
    sha256 = "sha256-1jLBGTQgrG+uv5SC5l4z06VmTszWQ7CaUJ0h0cHym+I=";
  };

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  configureFlags = [ "--enable-libscrypt-kdf" ];

  buildInputs = [ openssl ];

  nativeBuildInputs = [ getconf ];

  patchPhase = ''
    for f in Makefile.in autotools/Makefile.am libcperciva/cpusupport/Build/cpusupport.sh configure ; do
      substituteInPlace $f --replace "command -p " ""
    done

    patchShebangs tests/test_scrypt.sh
  '';

  doCheck = true;
  checkTarget = "test";
  nativeCheckInputs = lib.optionals stdenv.hostPlatform.isLinux [ util-linux ];

  meta = with lib; {
    description = "Encryption utility";
    mainProgram = "scrypt";
    homepage = "https://www.tarsnap.com/scrypt.html";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
