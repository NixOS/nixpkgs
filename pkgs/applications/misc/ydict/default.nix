{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, mpg123
}:

buildGoModule rec {
  pname = "ydict";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "ydict";
    rev = "v${version}";
    sha256 = "sha256-FcrkfWE1m5OveK4YPgVmUbL/jkh2NEs9bfeCHm2H9P8=";
  };

  vendorHash = "sha256-c5nQVQd4n978kFAAKcx5mX2Jz16ZOhS8iL/oxS1o5xs=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH ":" "${lib.makeBinPath [ mpg123 ]}";
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Yet another command-line Youdao Chinese dictionary";
    mainProgram = "ydict";
    homepage = "https://github.com/TimothyYe/ydict";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
