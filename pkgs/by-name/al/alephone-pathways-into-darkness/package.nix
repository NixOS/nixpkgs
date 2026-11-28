{ alephone, fetchurl }:

alephone.makeWrapper {
  pname = "pathways-into-darkness";
  desktopName = "Pathways-Into-Darkness";
  version = "1.4";

  zip = fetchurl {
    url = "https://simplici7y.s3.amazonaws.com/static/versions/item-7101/06de0635-0375-49c8-9cc2-bba1ebe26259/AOPID_v1.4.zip";
    hash = "sha256-mLsVZtO9OOJDg3bFErIZjrgUevq+gqXiSc9tE+liL2k=";
  };

  meta = {
    description = ''Port of the 1993 mac game "Pathways Into Darkness" by Bungie to the Aleph One engine'';
    homepage = "http://simplici7y.com/items/aleph-one-pathways-into-darkness";
  };

}
