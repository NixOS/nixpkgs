{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nano;
  colourType = lib.types.submodule {
    options = {
      bg = lib.mkOption {
        type = lib.types.enum [
          "black"
          "blue"
          "cyan"
          "green"
          "magenta"
          "normal"
          "red"
          "white"
          "yellow"
        ];
        default = "";
        description = ''
          Set the Background Colour.
          Normal means the default background colour.
        '';
      };
      fg = lib.mkOption {
        type = lib.types.enum [
          "black"
          "blue"
          "brightblue"
          "brightcyan"
          "brightgreen"
          "brightmagenta"
          "brightred"
          "brightwhite"
          "brightyellow"
          "cyan"
          "green"
          "magenta"
          "normal"
          "red"
          "white"
          "yellow"
        ];
        default = "";
        description = ''
          Set the Foreground Colour.
          Normal means the default foreground colour.
        '';
      };
    };
  };
  menuType = lib.types.enum [
    "main"
    "search"
    "replace"
    "replacewith"
    "yesno"
    "gotoline"
    "writeout"
    "insert"
    "extcmd"
    "help"
    "spell"
    "linter"
    "browser"
    "whereisfile"
    "gotodir"
    "all"
  ];
in
{
  ###### interface
  options = {
    programs.nano = {
      enable = lib.mkEnableOption "configuration of nano by creating /etc/nanorc";

      afterEnds = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Make <command>Ctrl+Right</command> stop at word ends instead of beginnings.
        '';
      };

      allowInsecureBackup = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          When backing up files, allow the backup to succeed even if its permissions cannot be (re)set due to special OS considerations.
          You should NOT enable this option unless you are sure you need it.
        '';
      };

      atBlanks = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          When soft line wrapping is enabled, make it wrap lines at blank characters (tabs and spaces) instead of always at the edge of the screen.
        '';
      };

      autoIndentation = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Automatically indent a newly created line to the same number of tabs and/or spaces as the previous line
            or as the next line if the previous line is the beginning of a paragraph.
        '';
      };

      backup = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          When saving a file, create a backup file by adding a tilde (~) to the file’s name.
        '';
      };

      backupDirectory = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Make and keep not just one backup file,
            but make and keep a uniquely numbered one every time a file is saved,
              when backups are enabled with <option>backup</option> or <command>−−backup</command> or <command>−B</command>.
          The uniquely numbered files are stored in the specified directory.
        '';
      };

      bindings = lib.mkOption {
        type = lib.types.listOf ( lib.types.submodule {
          options = {
            key = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The format of key should be one of:
                <itemizedlist>
                  <listitem><para>
                    <keycap>^X</keycap>
                    where <code>X</code> is a Latin letter or one of several ASCII characters
                      (<code>@</code>, <code>]</code>, <code>\</code>, <code>^</code>, <code>_</code>)
                    or the word <quote>Space</quote>.
                    Example: <keycap>^C</keycap>.
                  </para></listitem>
                  <listitem><para>
                    <keycombo>M−X</keycombo>
                    where <code>X</code> is any ASCII character except <code>[</code> or the word <quote>Space</quote>.
                    Example: <keycombo>M−8</keycombo>.
                  </para></listitem>
                  <listitem><para>
                    <keycombo>Sh−M−X</keycombo>
                    where <code>X</code> is a Latin letter.
                    Example: <keycombo>Sh−M−U</keycombo>.
                    By default, each <keycombo>Meta+letter</keycombo> keystroke does the same as the corresponding <keycombo>Shift+Meta+letter</keycombo>.
                    But when any <keycombo>Shift+Meta</keycombo> bind is made, that will no longer be the case, for all letters.
                  </para></listitem>
                  <listitem><para>
                    <keycap>FN</keycap>
                    where <code>N</code> is a numeric value from 1 to 24.
                    Example: <keycap>F10</keycap>.
                    (Often, <keycap>F13</keycap> to <keycap>F24</keycap> can be typed as <keycap>F1</keycap> to <keycap>F12</keycap> with <keycap>Shift</keycap>.)
                  </para></listitem>
                  <listitem><para><keycap>Ins</keycap> or <keycap>Del</keycap>.</para></listitem>
                </itemizedlist>
              '';
            };
            function = lib.mkOption {
              type = lib.types.nullOr ( lib.types.enum [
                "help"
                "cancel"
                "exit"
                "writeout"
                "savefile"
                "insert"
                "whereis"
                "wherewas"
                "findprevious"
                "findnext"
                "replace"
                "cut"
                "copy"
                "paste"
                "zap"
                "chopwordleft"
                "chopwordright"
                "cutrestoffile"
                "mark"
                "curpos"
                "wordcount"
                "speller"
                "formatter"
                "linter"
                "justify"
                "fulljustify"
                "indent"
                "unindent"
                "comment"
                "complete"
                "left"
                "right"
                "up"
                "down"
                "scrollup"
                "scrolldown"
                "prevword"
                "nextword"
                "home"
                "end"
                "beginpara"
                "endpara"
                "prevblock"
                "nextblock"
                "pageup"
                "pagedown"
                "firstline"
                "lastline"
                "gotoline"
                "findbracket"
                "prevbuf"
                "nextbuf"
                "verbatim"
                "tab"
                "enter"
                "delete"
                "backspace"
                "recordmacro"
                "runmacro"
                "undo"
                "redo"
                "refresh"
                "suspend"
                "casesens"
                "regexp"
                "backwards"
                "older"
                "newer"
                "flipreplace"
                "flipgoto"
                "flipexecute"
                "flippipe"
                "flipnewbuffer"
                "flipconvert"
                "dosformat"
                "macformat"
                "append"
                "prepend"
                "backup"
                "discardbuffer"
                "browser"
                "gotodir"
                "firstfile"
                "lastfile"
                "nohelp"
                "constantshow"
                "softwrap"
                "linenumbers"
                "whitespacedisplay"
                "nosyntax"
                "smarthome"
                "autoindent"
                "cutfromcursor"
                "nowrap"
                "tabstospaces"
                "mouse"
                "suspendable"
              ]);
              default = null;
              description = ''
                Function which will be executed when <option>key</option> is pressed.
                This option is mutually exclusive with <option>string</option>.
              '';
            };
            menu = lib.mkOption {
              type = menuType;
              default = "all";
              description = ''
                Menu where this <option>key</option> binding should apply.
              '';
            };
            string = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                String which will be inserted when <option>key</option> is pressed.
                This option is mutually exclusive with <option>function</option>.
              '';
            };
          };
        });
        default = [];
        description = ''
          List of Key-Bindings.
          Rebinds the given <option>key</option> to the given <option>function</option> in the given <option>menu</option>
            or in all menus where the function exists when all is used.
          See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum><refmiscinfo>Rebind Keys</refmiscinfo></citerefentry>.
        '';
      };

      boldText = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use bold instead of reverse video for the title bar, status bar, key combos, function tags, line numbers and selected text.
          This can be overridden by setting the options
            <option>titleColour</option>,
            <option>statusColour</option>,
            <option>keyColour</option>,
            <option>functionColour</option>,
            <option>numberColour</option> and
            <option>selectedColour</option>.
        '';
      };

      brackets = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Set the characters treated as closing brackets when justifying paragraphs.
          This may not include blank characters.
          Only closing punctuation (see <option>punctuation</option>),
            optionally followed by the specified closing brackets,
          can end sentences.
          The default value is ""’)>]}".
        '';
      };

      breakLongLines = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Automatically hard-wrap the current line when it becomes overlong.
        '';
      };

      caseSensitiveSearch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do case-sensitive searches by default.
        '';
      };

      constantShow = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Constantly display the cursor position in the status bar.
          This overrides the option <option>quickBlank</option>.
        '';
      };

      cutFromCursor = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use cut-from-cursor-to-end-of-line by default, instead of cutting the whole line.
        '';
      };

      emptyLine = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not use the line below the title bar, leaving it entirely blank.
        '';
      };

      errorColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Use this colour combination for the status bar when an error message is displayed.
          The default value is brightwhite for foregorund and red for background.
        '';
      };

      extendSyntax = lib.mkOption {
        type = lib.types.listOf ( lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = ''
                Name of syntax to extend.
              '';
            };
            command = lib.mkOption {
              type = lib.types.str;
              description = ''
                Extension command.
              '';
            };
          };
        });
        default = [];
        description = ''
          Extend the syntax previously defined as <option>name</option> with another <option>command</option>.
          This allows adding a new color, icolor, header, magic, formatter, linter, comment or tabgives command
            to an already defined syntax.
          Useful when you want to slightly improve a syntax defined in one of the system-installed files
            which normally are not writable.
        '';
      };

      fill = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          Set the target width for justifying and automatic hard-wrapping at this number of columns.
          If the value is 0 or less,
            wrapping will occur at the width of the screen minus number columns,
              allowing the wrap point to vary along with the width of the screen if the screen is resized.
          The default value is −8.
        '';
      };

      functionColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the colour combination to use for the function descriptions in the two help lines at the bottom of the screen.
        '';
      };

      guideStripe = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.unsigned;
        default = null;
        description = ''
          Draw a vertical stripe at the given column, to help judge the width of the text.
        '';
      };

      historyLog = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Save the last hundred search strings and replacement strings and executed commands,
            so they can be easily reused in later sessions.
        '';
      };

      include = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = ''
          Additional Files to add to /etc/nanorc.
        '';
      };

      jumpyScrolling = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Scroll the buffer contents per half-screen instead of per line.
        '';
      };

      keyColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the colour combination to use for the shortcut key combos in the two help lines at the bottom of the screen.
        '';
      };

      lineNumbers = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Display line numbers to the left of the text area.
        '';
      };

      locking = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable vim-style lock-files for when editing files.
        '';
      };

      matchBrackets = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Set the opening and closing brackets that can be found by bracket searches.
          This may not include blank characters.
          The opening set must come before the closing set and the two sets must be in the same order.
          The default value is "(<[{)>]}".
        '';
      };

      mouse = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable mouse support, if available for your system.
          When enabled, mouse clicks can be used to place the cursor, set the mark (with a double click) and execute shortcuts.
          The mouse will work in the X Window System and on the console when gpm is running.
          Text can still be selected through dragging by holding down the Shift key.
        '';
      };

      multiBuffer = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          When reading in a file with ^R, insert it into a new buffer by default.
        '';
      };

      nanorc = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          The system-wide nano configuration.
          See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum></citerefentry>.
        '';
        example = ''
          set nowrap
          set tabstospaces
          set tabsize 2
        '';
      };

      noConvert = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not convert files from DOS/Mac format.
        '';
      };

      noHelp = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not display the two help lines at the bottom of the screen.
        '';
      };

      noNewLines = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not automatically add a newline when a text does not end with one.
          This can cause you to save non-POSIX text files.
        '';
      };

      numberColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the colour combination to use for line numbers.
        '';
      };

      operatingDirectory = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          nano will only read and write files inside directory and its subdirectories.
          Also, the current directory is changed to here, so files are inserted from this directory.
          By default, the operating directory feature is turned off.
        '';
      };

      positionLog = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Save the cursor position of files between editing sessions.
          The cursor position is remembered for the 200 most-recently edited files.
        '';
      };

      preserve = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Preserve the XON and XOFF keys (^Q and ^S).
        '';
      };

      punctuation = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Set the characters treated as closing punctuation when justifying paragraphs.
          This may not include blank characters.
          Only the specfified closing punctuation, optionally followed by closing brackets (see <option>brackets</option>), can end sentences.
          The default value is "!.?".
        '';
      };

      quickBlank = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do quick status-bar blanking: status-bar messages will disappear after 1 keystroke instead of 25.
          The option <option>constantShow</option> overrides this.
        '';
      };

      quoteString = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Set the regular expression for matching the quoting part of a line.
          The default value is "^([ \t]*([!#%:;>|}]|//))+".
          Note that \t stands for an actual Tab character.
          This makes it possible to rejustify blocks of quoted text when composing email and to rewrap blocks of line comments when writing source code.
        '';
      };

      rawSequences = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Interpret escape sequences directly instead of asking ncurses to translate them.
          If you need this option to get your keyboard to work properly, please report a bug.
          Using this option disables nano’s mouse support.
        '';
      };

      rebindDelete = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Interpret the Delete and Backspace keys differently so that both Backspace and Delete work properly.
          You should only use this option when on your system either Backspace acts like Delete or Delete acts like Backspace.
        '';
      };

      regexSearch = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do regular-expression searches by default.
          Regular expressions in nano are of the extended type (ERE).
        '';
      };

      selectedColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the color combination to use for selected text.
        '';
      };

      showCursor = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Put the cursor on the highlighted item in the file browser, to aid braille users.
        '';
      };

      smartHome = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Make the Home key smarter.
          When Home is pressed anywhere but at the very beginning of non-whitespace characters on a line,
            the cursor will jump either forwards or backwards to that beginning.
          If the cursor is already at that position, it will jump to the true beginning of the line.
        '';
      };

      softWrap = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Display lines that exceed the screen’s width over multiple screen lines.
          You can make this soft-wrapping occur at whitespace instead of rudely at the screen’s edge, by using also <option>atBlanks</option>.
        '';
      };

      spellChecker = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Use the given program to do spell checking and correcting, instead of using the built-in corrector that calls hunspell or GNU spell.
        '';
      };

      statusColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the colour combination to use for the status bar.
        '';
      };

      stripeColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the colour combination to use for the vertical guiding stripe.
        '';
      };

      suspendable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Allow nano to be suspended (with ^Z by default).
        '';
      };

      syntaxHighlight = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable syntax highlight for various languages.
        '';
      };

      tabulatorSize = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 0;
        description = ''
          Use a tab size of number columns.
          The value of number must be greater than 0.
          The default value is 8.
        '';
      };

      tabulatorToSpaces = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Convert typed tabs to spaces.
        '';
      };

      temporaryFile = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Save automatically on exit, don’t prompt.
        '';
      };

      titleColour = lib.mkOption {
        type = lib.types.nullOr colourType;
        default = null;
        description = ''
          Specify the color combination to use for the title bar.
        '';
      };

      trimBlanks = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Remove trailing whitespace from wrapped lines when automatic hard-wrapping occurs or when text is justified.
        '';
      };

      unbindings = lib.mkOption {
        type = lib.types.listOf ( lib.types.submodule {
          options = {
            key = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The format of key should be one of:
                <itemizedlist>
                  <listitem><para>
                    <keycap>^X</keycap>
                    where <code>X</code> is a Latin letter or one of several ASCII characters
                      (<code>@</code>, <code>]</code>, <code>\</code>, <code>^</code>, <code>_</code>)
                    or the word <quote>Space</quote>.
                    Example: <keycap>^C</keycap>.
                  </para></listitem>
                  <listitem><para>
                    <keycombo>M−X</keycombo>
                    where <code>X</code> is any ASCII character except <code>[</code> or the word <quote>Space</quote>.
                    Example: <keycombo>M−8</keycombo>.
                  </para></listitem>
                  <listitem><para>
                    <keycombo>Sh−M−X</keycombo>
                    where <code>X</code> is a Latin letter.
                    Example: <keycombo>Sh−M−U</keycombo>.
                    By default, each <keycombo>Meta+letter</keycombo> keystroke does the same as the corresponding <keycombo>Shift+Meta+letter</keycombo>.
                    But when any <keycombo>Shift+Meta</keycombo> bind is made, that will no longer be the case, for all letters.
                  </para></listitem>
                  <listitem><para>
                    <keycap>FN</keycap>
                    where <code>N</code> is a numeric value from 1 to 24.
                    Example: <keycap>F10</keycap>.
                    (Often, <keycap>F13</keycap> to <keycap>F24</keycap> can be typed as <keycap>F1</keycap> to <keycap>F12</keycap> with <keycap>Shift</keycap>.)
                  </para></listitem>
                  <listitem><para><keycap>Ins</keycap> or <keycap>Del</keycap>.</para></listitem>
                </itemizedlist>
              '';
            };
            menu = lib.mkOption {
              type = menuType;
              default = "all";
              description = ''
                Menu where this <option>key</option> binding should apply.
              '';
            };
          };
        });
        default = [];
        description = ''
          List of Key-Unbindings.
          Unbin the given <option>key</option> in the given <option>menu</option>
            or in all menus where the function exists when all is used.
          See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum><refmiscinfo>Rebind Keys</refmiscinfo></citerefentry>.
        '';
      };

      unixFormat = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Save a file by default in Unix format.
          This overrides nano’s default behavior of saving a file in the format that it had.
          (This option has no effect when you also use <option>noConvert</option>.)
        '';
      };

      view = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Disallow file modification: read-only mode.
          This mode allows the user to open also other files for viewing,
            unless <command>−−restricted</command> is given on the command line.
        '';
      };

      whiteSpace = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Set the two characters used to indicate the presence of tabs and spaces.
          They must be single-column characters.
          The default pair for a UTF-8 locale is "»⋅" and for other locales ">.".
        '';
      };

      wordBounds = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Detect word boundaries differently by treating punctuation characters as parts of words.
        '';
      };

      wordChars = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Specify which other characters (besides the normal alphanumeric ones) should be considered as parts of words.
          This overrides the option <option>wordbounds</option>.
        '';
      };

      zap = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Let an unmodified Backspace or Delete erase the marked region
            (instead of a single character and without affecting the cutbuffer).
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    environment.etc.nanorc.text = lib.concatStringsSep "\n" (
      [
        "# This File was generated and will be overridden by the nixos-rebuid."
        ""
        "# == OPTIONS =="
      ]                                                                                                                     ++
      lib.optional cfg.afterEnds                  "set afterends"                                                           ++
      lib.optional cfg.allowInsecureBackup        "set allow_insecure_backup"                                               ++
      lib.optional cfg.atBlanks                   "set atblanks"                                                            ++
      lib.optional cfg.autoIndentation            "set autoindent"                                                          ++
      lib.optional cfg.backup                     "set backup"                                                              ++
      lib.optional (cfg.backupDirectory != "")    "set backupdir \"${cfg.backupDirectory}\""                                ++
      lib.optional cfg.boldText                   "set boldtext"                                                            ++
      lib.optional (cfg.brackets != "")           "set brackets \"${cfg.brackets}\""                                        ++
      lib.optional cfg.breakLongLines             "set breaklonglines"                                                      ++
      lib.optional cfg.caseSensitiveSearch        "set casesensitive"                                                       ++
      lib.optional cfg.constantShow               "set constantshow"                                                        ++
      lib.optional cfg.cutFromCursor              "set cutfromcursor"                                                       ++
      lib.optional cfg.emptyLine                  "set emptyline"                                                           ++
      lib.optional (cfg.errorColour != null)      "set errorcolor \"${cfg.errorColour.fg},${cfg.errorColour.bg}\""          ++
      lib.optional (cfg.fill != null)             "set fill ${toString cfg.fill}"                                           ++
      lib.optional (cfg.functionColour != null)   "set functioncolor \"${cfg.functionColour.fg},${cfg.functionColour.bg}\"" ++
      lib.optional (cfg.guideStripe != null)      "set guidestripe ${toString cfg.guideStripe}"                             ++
      lib.optional cfg.historyLog                 "set historylog"                                                          ++
      lib.optional cfg.jumpyScrolling             "set jumpyscrolling"                                                      ++
      lib.optional (cfg.keyColour != null)        "set keycolor \"${cfg.keyColour.fg},${cfg.keyColour.bg}\""                ++
      lib.optional cfg.lineNumbers                "set linenumbers"                                                         ++
      lib.optional cfg.locking                    "set locking"                                                             ++
      lib.optional (cfg.matchBrackets != "")      "set matchbrackets \"${cfg.matchBrackets}\""                              ++
      lib.optional cfg.mouse                      "set mouse"                                                               ++
      lib.optional cfg.multiBuffer                "set multibuffer"                                                         ++
      lib.optional cfg.noConvert                  "set noconvert"                                                           ++
      lib.optional cfg.noHelp                     "set nohelp"                                                              ++
      lib.optional cfg.noNewLines                 "set nonewlines"                                                          ++
      lib.optional (cfg.numberColour != null)     "set numbercolor \"${cfg.numberColour.fg},${cfg.numberColour.bg}\""       ++
      lib.optional (cfg.operatingDirectory != "") "set operatingdir \"${cfg.operatingDirectory}\""                          ++
      lib.optional cfg.positionLog                "set positionlog"                                                         ++
      lib.optional cfg.preserve                   "set preserve"                                                            ++
      lib.optional (cfg.punctuation != "")        "set punct \"${cfg.punctuation}\""                                        ++
      lib.optional cfg.quickBlank                 "set quickblank"                                                          ++
      lib.optional (cfg.quoteString != "")        "set quotestr \"${cfg.quoteString}\""                                     ++
      lib.optional cfg.rawSequences               "set rawsequences"                                                        ++
      lib.optional cfg.rebindDelete               "set rebinddelete"                                                        ++
      lib.optional cfg.regexSearch                "set regexp"                                                              ++
      lib.optional (cfg.selectedColour != null)   "set selectedcolor \"${cfg.selectedColour.fg},${cfg.selectedColour.bg}\"" ++
      lib.optional cfg.showCursor                 "set showcursor"                                                          ++
      lib.optional cfg.smartHome                  "set smarthome"                                                           ++
      lib.optional cfg.softWrap                   "set softwrap"                                                            ++
      lib.optional (cfg.spellChecker != "")       "set speller \"${cfg.spellChecker}\""                                     ++
      lib.optional (cfg.statusColour != null)     "set statuscolor \"${cfg.statusColour.fg},${cfg.statusColour.bg}\""       ++
      lib.optional (cfg.stripeColour != null)     "set stripecolor \"${cfg.stripeColour.fg},${cfg.stripeColour.bg}\""       ++
      lib.optional cfg.suspendable                "set suspendable"                                                         ++
      lib.optional (cfg.tabulatorSize > 0)        "set tabsize ${toString cfg.tabulatorSize}"                               ++
      lib.optional cfg.tabulatorToSpaces          "set tabstospaces"                                                        ++
      lib.optional cfg.temporaryFile              "set tempfile"                                                            ++
      lib.optional (cfg.titleColour != null)      "set titlecolor \"${cfg.titleColour.fg},${cfg.titleColour.bg}\""          ++
      lib.optional cfg.trimBlanks                 "set trimblanks"                                                          ++
      lib.optional cfg.unixFormat                 "set unix"                                                                ++
      lib.optional cfg.view                       "set view"                                                                ++
      lib.optional (cfg.whiteSpace != "")         "set whitespace \"${cfg.whiteSpace}\""                                    ++
      lib.optional cfg.wordBounds                 "set wordbounds"                                                          ++
      lib.optional (cfg.wordChars != "")          "set wordchars \"${cfg.wordChars}\""                                      ++
      lib.optional cfg.zap                        "set zap"                                                                 ++
      [
        ""
        "# == SYNTAX HIGHLIGHTING =="
      ]                                                                                                                     ++
      lib.optional cfg.syntaxHighlight            "include \"${pkgs.nano}/share/nano/*.nanorc\""                            ++
      lib.lists.forEach cfg.include       ( file: "include \"${file}\""                       )                             ++
      lib.lists.forEach cfg.extendSyntax  ( this: "extendsyntax ${this.name} ${this.command}" )                             ++
      [
        ""
        "# == REBINDING KEYS =="
      ]                                                                                                                     ++
      lib.lists.forEach cfg.unbindings    ( this: "unbind ${this.key} ${this.menu}" )                                       ++
      lib.lists.forEach cfg.bindings
      (
        this:
        if this.function == null
        then "bind ${this.key} \"${this.string}\" ${this.menu}"
        else "bind ${this.key} ${this.function} ${this.menu}"
      )                                                                                                                     ++
      [
        ""
        "# == CUSTOM SETTINGS =="
      ]                                                                                                                     ++
      [ cfg.nanorc ]
    );
  };
}
