{ lib
, buildGoModule
, fetchFromSourcehut
, installShellFiles
, scdoc
}:

buildGoModule rec {
  pname = "hut";
  version = "unstable-2022-01-18";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "hut";
    rev = "c039cb53135a5e9fdd4bc66e2626e3ae6e857a34";
    sha256 = "0gfl6zdvdiip9bzvya98sln4b7bd3g1isrqfrwpcwap49xbczc3f";
  };

  vendorSha256 = "sha256-6CgHc2ASaci5ybxAvUGJHjtTFllr4RghPw8RIsGmHdo=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postBuild = ''
    scdoc < doc/hut.1.scd > hut.1
    installManPage hut.1
  '';

  meta = with lib; {
    description = "A CLI tool for sr.ht";
    homepage = "https://sr.ht/~emersion/hut/";
    license = licenses.agpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
