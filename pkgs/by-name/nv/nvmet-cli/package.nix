{
  lib,
  python3Packages,
  fetchurl,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nvmet-cli";
  version = "0.7";
  format = "setuptools";

  src = fetchurl {
    url = "ftp://ftp.infradead.org/pub/nvmetcli/nvmetcli-${finalAttrs.version}.tar.gz";
    sha256 = "051y1b9w46azy35118154c353v3mhjkdzh6h59brdgn5054hayj2";
  };

  buildInputs = with python3Packages; [ nose2 ];

  propagatedBuildInputs = with python3Packages; [ configshell-fb ];

  # This package requires the `nvmet` kernel module to be loaded for tests.
  doCheck = false;

  meta = {
    description = "NVMe target CLI";
    mainProgram = "nvmetcli";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ hoverbear ];
  };
})
