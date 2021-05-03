{ stdenv, lib, fetchFromGitHub, installShellFiles, libiconv, ruby ? null }:

stdenv.mkDerivation rec {
  pname = "mblaze";
  version = "1.1";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ ruby ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "sha256-Ho2Qoxs93ig4yYUOaoqdYnLA8Y4+7CfRM0dju89JOa4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion contrib/_mblaze
  '' + lib.optionalString (ruby != null) ''
    install -Dt $out/bin contrib/msuck contrib/mblow
  '';

  meta = with lib; {
    homepage = "https://github.com/leahneukirchen/mblaze";
    description = "Unix utilities for processing and interacting with mail messages which are stored in maildir folders";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = [ maintainers.ajgrf ];
  };
}
