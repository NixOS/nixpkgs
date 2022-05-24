{ fetchFromGitHub, lib, i3 }:

i3.overrideAttrs (oldAttrs: rec {
  pname = "i3-rounded";
  version = "524c9f7b50f8c540b2ae3480b242c30d8775f98e";

  src = fetchFromGitHub {
    owner = "LinoBigatti";
    repo = "i3-rounded";
    rev = version;
    sha256 = "0y7m1s1y8f9vgkp7byi33js8n4rigiykd71s936i5d4rwlzrxiwm";
  };

  meta = with lib; {
    description = "A fork of i3-gaps that adds rounding to window corners";
    homepage = "https://github.com/LinoBigatti/i3-rounded";
    maintainers = with maintainers; [ marsupialgutz ];
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.netbsd ++ platforms.openbsd;

    longDescription = ''
      i3-rounded is a fork of i3-gaps that adds rounding to window corners.
      It was originally made by resloved and this repo strives to keep it
      (hopefully) up to date.
    '';
  };
})
