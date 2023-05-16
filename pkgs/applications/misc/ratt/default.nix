{ buildGoModule, fetchFromSourcehut, lib }:
buildGoModule rec {
  pname = "ratt";
<<<<<<< HEAD
  version = "unstable-2023-02-12";
=======
  version = "unstable-2022-01-11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromSourcehut {
    owner = "~ghost08";
    repo = "ratt";
<<<<<<< HEAD
    rev = "ed1a675685b9d86d6602e168199ba9b4260f5f06";
    hash = "sha256-HfS97Lxt6FAj/2/WAzLI06F/h6TP5m2lHHOTAs8XNFY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-6cpHDwnxdc/9YPj77JVuT5ZDFjKkF6nBX4RgZr/9fFY=";
=======
    rev = "eac7e14b15ad4e916e7d072780397c414c740630";
    hash = "sha256-/WzPF98MovNg4t5NJhL2Z1bAFDG/3I56M9YgRJF7Wjk=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-4TEdnJ7lCuBka6rtoKowf5X3VqCgfwvGHeJ5B5Q5C20=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests try to access the internet to scrape websites
  doCheck = false;

  meta = with lib; {
    description = "A tool for converting websites to rss/atom feeds";
    homepage = "https://git.sr.ht/~ghost08/ratt";
    license = licenses.mit;
    maintainers = with maintainers; [ kmein ];
<<<<<<< HEAD
=======
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
