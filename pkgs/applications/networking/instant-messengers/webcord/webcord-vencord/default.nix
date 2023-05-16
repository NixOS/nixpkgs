{ webcord
, substituteAll
<<<<<<< HEAD
, lib
, vencord-web-extension
}:

webcord.overrideAttrs (old: {
  pname = "webcord-vencord";

  patches = (old.patches or [ ]) ++ [
    (substituteAll {
      src = ./add-extension.patch;
      vencord = vencord-web-extension;
=======
, callPackage
, lib
}:
webcord.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    (substituteAll {
      src = ./add-extension.patch;
      vencord = callPackage ./vencord-web-extension { };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    })
  ];

  meta = with lib; old.meta // {
    description = "Webcord with Vencord web extension";
    maintainers = with maintainers; [ FlafyDev NotAShelf ];
  };
})
