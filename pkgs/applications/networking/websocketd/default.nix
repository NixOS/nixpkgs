{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "websocketd";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "joewalnes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qc4yi4kwy7bfi3fb17w58ff0i95yi6m4syldh8j79930syr5y8q";
  };

  modSha256 = "18hamj557ln8k3vmvcrpvnydjr1dy7zi9490iacwdldw5vp870xs";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Turn any program that uses STDIN/STDOUT into a WebSocket server";
    homepage = "http://websocketd.com/";
    maintainers = [ maintainers.bjornfor ];
    license = licenses.bsd2;
  };
}
