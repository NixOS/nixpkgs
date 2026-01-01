{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  php,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudlog";
<<<<<<< HEAD
  version = "2.8.4";
=======
  version = "2.7.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "magicbug";
    repo = "Cloudlog";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Di4x55EESuS6R8b0HeJHAKzqhl5JTzxputKx6SmX8CM=";
=======
    hash = "sha256-p9PmWRKvKGGZrexZJwYtb+LYto9npZ606QVo4pvDBak=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace index.php \
      --replace "define('ENVIRONMENT', 'development');" "define('ENVIRONMENT', 'production');"
  '';

  installPhase = ''
    mkdir $out/
    cp -R ./* $out
  '';

  passthru = {
    tests = {
      inherit (nixosTests) cloudlog;
    };
    updateScript = nix-update-script { };
  };

<<<<<<< HEAD
  meta = {
    description = "Web based amateur radio logging application built using PHP & MySQL";
    license = lib.licenses.mit;
    homepage = "https://www.magicbug.co.uk/cloudlog";
    platforms = php.meta.platforms;
    maintainers = with lib.maintainers; [ haennetz ];
=======
  meta = with lib; {
    description = "Web based amateur radio logging application built using PHP & MySQL";
    license = licenses.mit;
    homepage = "https://www.magicbug.co.uk/cloudlog";
    platforms = php.meta.platforms;
    maintainers = with maintainers; [ melling ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
