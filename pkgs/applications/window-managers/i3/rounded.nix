{ fetchFromGitHub, lib, i3, pcre }:

i3.overrideAttrs (oldAttrs: rec {
  pname = "i3-rounded";
  version = "unstable-2021-10-03";

  src = fetchFromGitHub {
    owner = "LinoBigatti";
    repo = "i3-rounded";
    rev = "524c9f7b50f8c540b2ae3480b242c30d8775f98e";
    sha256 = "0y7m1s1y8f9vgkp7byi33js8n4rigiykd71s936i5d4rwlzrxiwm";
  };

  buildInputs = oldAttrs.buildInputs ++ [ pcre ];

  meta = with lib; {
    description = "Fork of i3-gaps that adds rounding to window corners";
    homepage = "https://github.com/LinoBigatti/i3-rounded";
    maintainers = with maintainers; [ marsupialgutz ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
})
