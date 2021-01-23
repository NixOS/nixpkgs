{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "KAOIx401G/kB/TclhidOnUja1P+mLo/mUwAqGJfVfyg=";
  };

  vendorSha256 = "rOEM7iEkm42g8yJxY7qdTCSbkPMDHqlAsK7/ud8IDLY=";

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    sed -i "s:amfora:$out/bin/amfora:" amfora.desktop
    install -Dm644 amfora.desktop -t $out/share/applications
  '';

  meta = with lib; {
    description = "A fancy terminal browser for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/amfora";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ deifactor ];
  };
}
