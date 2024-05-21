# Input Methods {#module-services-input-methods}

Input methods are an operating system component that allows any data, such as
keyboard strokes or mouse movements, to be received as input. In this way
users can enter characters and symbols not found on their input devices.
Using an input method is obligatory for any language that has more graphemes
than there are keys on the keyboard.

The following input methods are available in NixOS:

  - IBus: The intelligent input bus.
  - Fcitx5: The next generation of fcitx, addons (including engines, dictionaries, skins) can be added using `i18n.inputMethod.fcitx5.addons`.
  - Nabi: A Korean input method based on XIM.
  - Uim: The universal input method, is a library with a XIM bridge.
  - Hime: An extremely easy-to-use input method framework.
  - Kime: Korean IME

## IBus {#module-services-input-methods-ibus}

IBus is an Intelligent Input Bus. It provides full featured and user
friendly input method user interface.

The following snippet can be used to configure IBus:

```nix
{
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ anthy hangul mozc ];
  };
}
```

`i18n.inputMethod.ibus.engines` is optional and can be used
to add extra IBus engines.

Available extra IBus engines are:

  - Anthy (`ibus-engines.anthy`): Anthy is a system for
    Japanese input method. It converts Hiragana text to Kana Kanji mixed text.
  - Hangul (`ibus-engines.hangul`): Korean input method.
  - m17n (`ibus-engines.m17n`): m17n is an input method that
    uses input methods and corresponding icons in the m17n database.
  - mozc (`ibus-engines.mozc`): A Japanese input method from
    Google.
  - Table (`ibus-engines.table`): An input method that load
    tables of input methods.
  - table-others (`ibus-engines.table-others`): Various
    table-based input methods. To use this, and any other table-based input
    methods, it must appear in the list of engines along with
    `table`. For example:

    ```nix
    {
      ibus.engines = with pkgs.ibus-engines; [ table table-others ];
    }
    ```

To use any input method, the package must be added in the configuration, as
shown above, and also (after running `nixos-rebuild`) the
input method must be added from IBus' preference dialog.

### Troubleshooting {#module-services-input-methods-troubleshooting}

If IBus works in some applications but not others, a likely cause of this
is that IBus is depending on a different version of `glib`
to what the applications are depending on. This can be checked by running
`nix-store -q --requisites <path> | grep glib`,
where `<path>` is the path of either IBus or an
application in the Nix store. The `glib` packages must
match exactly. If they do not, uninstalling and reinstalling the
application is a likely fix.

## Fcitx5 {#module-services-input-methods-fcitx}

Fcitx5 is an input method framework with extension support. It has three
built-in Input Method Engine, Pinyin, QuWei and Table-based input methods.

The following snippet can be used to configure Fcitx:

```nix
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-hangul fcitx5-m17n ];
  };
}
```

`i18n.inputMethod.fcitx5.addons` is optional and can be
used to add extra Fcitx5 addons.

Available extra Fcitx5 addons are:

  - Anthy (`fcitx5-anthy`): Anthy is a system for
    Japanese input method. It converts Hiragana text to Kana Kanji mixed text.
  - Chewing (`fcitx5-chewing`): Chewing is an
    intelligent Zhuyin input method. It is one of the most popular input
    methods among Traditional Chinese Unix users.
  - Hangul (`fcitx5-hangul`): Korean input method.
  - Unikey (`fcitx5-unikey`): Vietnamese input method.
  - m17n (`fcitx5-m17n`): m17n is an input method that
    uses input methods and corresponding icons in the m17n database.
  - mozc (`fcitx5-mozc`): A Japanese input method from
    Google.
  - table-others (`fcitx5-table-other`): Various
    table-based input methods.
  - chinese-addons (`fcitx5-chinese-addons`): Various chinese input methods.
  - rime (`fcitx5-rime`): RIME support for fcitx5.

## Nabi {#module-services-input-methods-nabi}

Nabi is an easy to use Korean X input method. It allows you to enter
phonetic Korean characters (hangul) and pictographic Korean characters
(hanja).

The following snippet can be used to configure Nabi:

```nix
{
  i18n.inputMethod = {
    enabled = "nabi";
  };
}
```

## Uim {#module-services-input-methods-uim}

Uim (short for "universal input method") is a multilingual input method
framework. Applications can use it through so-called bridges.

The following snippet can be used to configure uim:

```nix
{
  i18n.inputMethod = {
    enabled = "uim";
  };
}
```

Note: The [](#opt-i18n.inputMethod.uim.toolbar) option can be
used to choose uim toolbar.

## Hime {#module-services-input-methods-hime}

Hime is an extremely easy-to-use input method framework. It is lightweight,
stable, powerful and supports many commonly used input methods, including
Cangjie, Zhuyin, Dayi, Rank, Shrimp, Greek, Korean Pinyin, Latin Alphabet,
etc...

The following snippet can be used to configure Hime:

```nix
{
  i18n.inputMethod = {
    enabled = "hime";
  };
}
```

## Kime {#module-services-input-methods-kime}

Kime is Korean IME. it's built with Rust language and let you get simple, safe, fast Korean typing

The following snippet can be used to configure Kime:

```nix
{
  i18n.inputMethod = {
    enabled = "kime";
  };
}
```
