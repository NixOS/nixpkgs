{ lib, fetchurl }:

let
  pname = "caprine";
  version = "2.52.2";
  name = "${pname}-${version}";
in {

  inherit pname version name;

  appimage.src = fetchurl {
    url =
      "https://github.com/sindresorhus/caprine/releases/download/v${version}/Caprine-${version}.AppImage";
    name = "Caprine-${version}.AppImage";
    sha256 = "0zxpn7yy58p95db4ymqng1kq4f3k6qxqdy5lj7rd9h4649b8bk20";
  };

  dmg.src = fetchurl {
    url =
      "https://github.com/sindresorhus/caprine/releases/download/v${version}/Caprine-${version}.dmg";
    name = "Caprine-${version}.dmg";
    sha256 = "1wmfylxrq62npfxzxv5jj6s30436mn5jvhp30d7gc1g5mzhaphay";
  };

  metaCommon = with lib; {
    description = "An elegant Facebook Messenger desktop app";
    homepage = "https://sindresorhus.com/caprine/";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
}
