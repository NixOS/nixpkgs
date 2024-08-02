{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "gpodder2go";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "oxtyped";
    repo = "gpodder2go";
    rev = "v${version}";
    hash = "sha256-DLUVANrePlnzEGmyjmrtQbus8zjPytBJUIg2MSqD8go=";
  };

  # Skip checks due to reliance on an external database.
  doCheck = false;

  vendorHash = "sha256-7VkpRyoqWFfZODrNq5YjgHFKM3/7u/4G5b/930aoqyA=";

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Single Binary Podcast Subscription Management";
    homepage = "https://github.com/oxtyped/gpodder2go";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ foehammer ];
    mainProgram = "gpodder2go";
  };
}
