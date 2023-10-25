{ webcord
, substituteAll
, lib
, vencord-web-extension
, electron_24
}:

(webcord.overrideAttrs (old: {
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
})).override {
  # Webcord has updated to electron 25, but that causes a segfault
  # when launching webcord-vencord on wayland, so downgrade it for now.
  electron_25 = electron_24;
}
