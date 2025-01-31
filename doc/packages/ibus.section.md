# ibus-engines.typing-booster {#sec-ibus-typing-booster}

This package is an ibus-based completion method to speed up typing.

## Activating the engine {#sec-ibus-typing-booster-activate}

IBus needs to be configured accordingly to activate `typing-booster`. The configuration depends on the desktop manager in use. For detailed instructions, please refer to the [upstream docs](https://mike-fabian.github.io/ibus-typing-booster/).

On NixOS, you need to explicitly enable `ibus` with given engines before customizing your desktop to use `typing-booster`. This can be achieved using the `ibus` module:

```nix
{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ typing-booster ];
  };
}
```

## Using custom hunspell dictionaries {#sec-ibus-typing-booster-customize-hunspell}

The IBus engine is based on `hunspell` to support completion in many languages. By default, the dictionaries `de-de`, `en-us`, `fr-moderne` `es-es`, `it-it`, `sv-se` and `sv-fi` are in use. To add another dictionary, the package can be overridden like this:

```nix
ibus-engines.typing-booster.override { langs = [ "de-at" "en-gb" ]; }
```

_Note: each language passed to `langs` must be an attribute name in `pkgs.hunspellDicts`._

## Built-in emoji picker {#sec-ibus-typing-booster-emoji-picker}

The `ibus-engines.typing-booster` package contains a program named `emoji-picker`. To display all emojis correctly, a special font such as `noto-fonts-color-emoji` is needed:

On NixOS, it can be installed using the following expression:

```nix
{ pkgs, ... }: {
  fonts.packages = with pkgs; [ noto-fonts-color-emoji ];
}
```
