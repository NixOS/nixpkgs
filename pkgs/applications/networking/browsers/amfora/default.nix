{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "sha256-q83fKs27vkrUs3+AoKZ2342llj6u3bvbLsdnT9DnVUs=";
  };

  vendorSha256 = "sha256-0blHwZwOcgC4LcmZSJPRvyQzArCsaMGgIw+cesO+qOo=";

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    sed -i "s:amfora:$out/bin/amfora:" amfora.desktop
    install -Dm644 amfora.desktop -t $out/share/applications
  '';

  meta = with lib; {
    description = "A fancy terminal browser for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/amfora";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ deifactor ];
    changelog = "https://github.com/makeworld-the-better-one/amfora/blob/v${version}/CHANGELOG.md";
  };
}
