final: prev: {
  lumina = {
    lumina = prev.lumina.lumina.overrideAttrs (old: {
      # Add anything missing or remove what needs to be removed.
      # Upstream already uses libsForQt5.kwindowsystem. Let's just return old.
    });
  } // (builtins.removeAttrs prev.lumina ["lumina"]);
}
