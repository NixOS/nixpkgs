{
  callPackage,
}:
{
  adjust-sound-volume = callPackage ./adjust-sound-volume { };

  ajt-card-management = callPackage ./ajt-card-management { };

  anki-connect = callPackage ./anki-connect { };

  anki-quizlet-importer-extended = callPackage ./anki-quizlet-importer-extended { };

  image-occlusion-enhanced = callPackage ./image-occlusion-enhanced { };

  local-audio-yomichan = callPackage ./local-audio-yomichan { };

  passfail2 = callPackage ./passfail2 { };

  puppy-reinforcement = callPackage ./puppy-reinforcement { };

  recolor = callPackage ./recolor { };

  reviewer-refocus-card = callPackage ./reviewer-refocus-card { };

  review-heatmap = callPackage ./review-heatmap { };

  yomichan-forvo-server = callPackage ./yomichan-forvo-server { };
}
