{
  lib,
  fetchurl,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "flawfinder";
  version = "2.0.19";
  pyproject = true;

  src = fetchurl {
    url = "https://dwheeler.com/flawfinder/flawfinder-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-/lUJgdNwq/oKKWcTRswLA4Ipqb2QsjnqsPAfEiEt9hg=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  # Project is using a combination of bash/Python for the tests
  doCheck = false;

  pythonImportsCheck = [ "flawfinder" ];

  meta = {
    description = "Tool to examines C/C++ source code for security flaws";
    mainProgram = "flawfinder";
    homepage = "https://dwheeler.com/flawfinder/";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.all;
  };
})
