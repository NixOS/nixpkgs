{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "amfora";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = "amfora";
    rev = "v${version}";
    sha256 = "1z4r1yqy5nkfa7yqcsqpqfdcghw8idryzb3s6d6ibca47r0qlcvw";
  };

  vendorSha256 = "0xj2s14dq10fwqqxjn4d8x6zljd5d15gjbja2gb75rfv09s4fdgv";

  meta = with lib; {
    description = "A fancy terminal browser for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/amfora";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ deifactor ];
  };
}
