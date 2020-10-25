{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "011h5xzwiafh3fdp9wil8n618p45ph9swa66lw6s82ijpiizz79s";
  };

  vendorSha256 = "10f3bh3r3jc1185r8r1ihg8rprdpl8qwg5b6wqwsda96ydkbpi2b";

  postInstall = ''
    sed -i "s:amfora:$out/bin/amfora:" amfora.desktop
    install -Dm644 amfora.desktop -t $out/share/applications
  '';

  doCheck = false;

  meta = with lib; {
    description = "A fancy terminal browser for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/amfora";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ deifactor ];
  };
}
