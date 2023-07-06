{ lib
, flutter
, fetchFromGitHub
, autoPatchelfHook
}:

flutter.buildFlutterApplication rec {
  pname = "kitchenowl";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "TomBursch";
    repo = "kitchenowl";
    rev = "refs/tags/v${version}";
    hash = "sha256-fhqs9jWhS2YC+zpE37mJgs3vcJHi+8AdSbk1S8Ai+LQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  depsListFile = ./deps.json;
  vendorHash = "sha256-tm35ZdrguWiEQ26l7A/3pv/YTpv2BgMiE7IIWYSdlIs=";

  meta = {
    homepage = "https://kitchenowl.org";
    description = "A smart grocery list and recipe manager";
    longDescription = ''
      KitchenOwl is a smart self-hosted grocery list and recipe manager.
      Easily add items to your shopping list before you go shopping.
      You can also create recipes and get suggestions on what you want to cook.
      Track your expenses so you know how much you've spent.
    '';
    changelog = "https://github.com/TomBursch/kitchenowl/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
