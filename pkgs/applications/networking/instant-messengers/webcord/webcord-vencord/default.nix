{ webcord
, substituteAll
, lib
, vencord-web-extension
}:

webcord.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [
    (substituteAll {
      src = ./add-extension.patch;
      vencord = vencord-web-extension;
    })
  ];

  meta = with lib; old.meta // {
    description = "Webcord with Vencord web extension";
    maintainers = with maintainers; [ FlafyDev NotAShelf ];
  };
})
