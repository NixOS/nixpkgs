{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, mpg123
}:

buildGoModule rec {
  pname = "ydict";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "TimothyYe";
    repo = "ydict";
    rev = "v${version}";
    sha256 = "sha256-qrGOrqI+PXsDNCmgcCPDNn6qUYu2emhYSkYsz4sj27M=";
  };

  vendorSha256 = "sha256-c5nQVQd4n978kFAAKcx5mX2Jz16ZOhS8iL/oxS1o5xs=";

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
    homepage = "https://github.com/TimothyYe/ydict";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
