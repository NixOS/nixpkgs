{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "1f5r12hmdgj26p4ss5pcpfcvqlcn19fr9xvvvk2izckcr48p4fy7";
  };

  vendorSha256 = "0mkk7xxfxxp1w9890mkmag11mzxhy2zmh8v1macpyp1zmzgs21f8";

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
