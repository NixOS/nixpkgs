{ webcord
, substituteAll
, callPackage
, lib
}:
webcord.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    (substituteAll {
      src = ./add-extension.patch;
      vencord = callPackage ./vencord-web-extension { };
    })
  ];

  meta = with lib; old.meta // {
    description = "Webcord with Vencord web extension";
    maintainers = with maintainers; [ FlafyDev NotAShelf ];
  };
})
