{
  fetchurl,
  less,
}:

less.overrideAttrs (
  finalAttrs: _: {
    pname = "${less.pname}-unstable";
    version = "711";

    src = fetchurl {
      url = "https://www.greenwoodsoftware.com/less/less-${finalAttrs.version}-beta.tar.gz";
      hash = "sha256-ac5cSrOzIzYL/zuOKH+bwnX1etgkLq0mT9NN3WE67o4=";
    };

    __structuredAttrs = true;
  }
)
