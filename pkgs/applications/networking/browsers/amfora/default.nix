{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "sha256-Vj5aFSpyC7X9e9A9r4FAI6a0U8dx8uj7bpAFrQjLSzo=";
  };

  vendorSha256 = "sha256-XtiGj2Tr6sSBduIjBspeZpYaSTd6x6EVf3VEVMXDAD0=";

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
