/* List of categories
    ```nix
    handle = {
      # Required
      name = "Category Name";
      description = ''
        Description of category
      '';
      relatedCategories = [ related01 related02 . . . ];
    };
    ```

    where

    - `handle` is the handle you are going to use in nixpkgs expressions;
       usually the same as the name but in camelCase
    - `name` is the category name
    - `description` is a description of the category
    - `relatedCategories` is a (possibly empty) list of related categories (like
      the `handle` above)

    More fields may be added in the future.

    When editing this file:
     * do not modify any of
         - mainCategories
         - additionalCategories
         - reservedCategories
       except by reasons of force majeure (e.g. an update on the Freedesktop.org
       Desktop Menu Specification);
     * keep the lists alphabetically sorted;
     * test the validity of the format with:
         nix-build lib/tests/categories.nix
*/
{ lib }:

let
  mainCategories = {
    audioVideo = {
      name = "audioVideo";
      description = ''
      '';
      relatedCategories = [];
    };
    audio = {
      name = "audio";
      description = ''
      '';
      relatedCategories = [];
    };
    video = {
      name = "video";
      description = ''
      '';
      relatedCategories = [];
    };
    development = {
      name = "development";
      description = ''
      '';
      relatedCategories = [];
    };
    education = {
      name = "education";
      description = ''
      '';
      relatedCategories = [];
    };
    game = {
      name = "game";
      description = ''
      '';
      relatedCategories = [];
    };
    graphics = {
      name = "graphics";
      description = ''
      '';
      relatedCategories = [];
    };
    network = {
      name = "network";
      description = ''
      '';
      relatedCategories = [];
    };
    office = {
      name = "office";
      description = ''
      '';
      relatedCategories = [];
    };
    science = {
      name = "science";
      description = ''
      '';
      relatedCategories = [];
    };
    settings = {
      name = "settings";
      description = ''
      '';
      relatedCategories = [];
    };
    system = {
      name = "system";
      description = ''
      '';
      relatedCategories = [];
    };
    utility = {
      name = "utility";
      description = ''
      '';
      relatedCategories = [];
    };
  };

  additionalCategories = {
    _2DGraphics = {
      name = "2DGraphics";
      description = ''
        2D based graphical application
      '';
      relatedCategories = [];
    };
    _3DGraphics = {
      name = "3DGraphics";
      description = ''
      '';
      relatedCategories = [];
    };
    accessibility = {
      name = "accessibility";
      description = ''
      '';
      relatedCategories = [];
    };
    actionGame = {
      name = "actionGame";
      description = ''
      '';
      relatedCategories = [];
    };
    adult = {
      name = "adult";
      description = ''
      '';
      relatedCategories = [];
    };
    adventureGame = {
      name = "adventureGame";
      description = ''
      '';
      relatedCategories = [];
    };
    amusement = {
      name = "amusement";
      description = ''
      '';
      relatedCategories = [];
    };
    arcadeGame = {
      name = "arcadeGame";
      description = ''
      '';
      relatedCategories = [];
    };
    archiving = {
      name = "archiving";
      description = ''
      '';
      relatedCategories = [];
    };
    art = {
      name = "art";
      description = ''
      '';
      relatedCategories = [];
    };
    artificialIntelligence = {
      name = "artificialIntelligence";
      description = ''
      '';
      relatedCategories = [];
    };
    astronomy = {
      name = "astronomy";
      description = ''
      '';
      relatedCategories = [];
    };
    audioVideoEditing = {
      name = "audioVideoEditing";
      description = ''
      '';
      relatedCategories = [];
    };
    biology = {
      name = "biology";
      description = ''
      '';
      relatedCategories = [];
    };
    blocksGame = {
      name = "blocksGame";
      description = ''
      '';
      relatedCategories = [];
    };
    boardGame = {
      name = "boardGame";
      description = ''
      '';
      relatedCategories = [];
    };
    building = {
      name = "building";
      description = ''
      '';
      relatedCategories = [];
    };
    calculator = {
      name = "calculator";
      description = ''
      '';
      relatedCategories = [];
    };
    calendar = {
      name = "calendar";
      description = ''
      '';
      relatedCategories = [];
    };
    cardGame = {
      name = "cardGame";
      description = ''
      '';
      relatedCategories = [];
    };
    chart = {
      name = "chart";
      description = ''
      '';
      relatedCategories = [];
    };
    chat = {
      name = "chat";
      description = ''
      '';
      relatedCategories = [];
    };
    chemistry = {
      name = "chemistry";
      description = ''
      '';
      relatedCategories = [];
    };
    clock = {
      name = "clock";
      description = ''
      '';
      relatedCategories = [];
    };
    compression = {
      name = "compression";
      description = ''
      '';
      relatedCategories = [];
    };
    computerScience = {
      name = "computerScience";
      description = ''
      '';
      relatedCategories = [];
    };
    consoleOnly = {
      name = "consoleOnly";
      description = ''
      '';
      relatedCategories = [];
    };
    construction = {
      name = "construction";
      description = ''
      '';
      relatedCategories = [];
    };
    contactManagement = {
      name = "contactManagement";
      description = ''
      '';
      relatedCategories = [];
    };
    core = {
      name = "core";
      description = ''
      '';
      relatedCategories = [];
    };
    dataVisualization = {
      name = "dataVisualization";
      description = ''
      '';
      relatedCategories = [];
    };
    database = {
      name = "database";
      description = ''
      '';
      relatedCategories = [];
    };
    debugger = {
      name = "debugger";
      description = ''
      '';
      relatedCategories = [];
    };
    desktopSettings = {
      name = "desktopSettings";
      description = ''
      '';
      relatedCategories = [];
    };
    dialup = {
      name = "dialup";
      description = ''
      '';
      relatedCategories = [];
    };
    dictionary = {
      name = "dictionary";
      description = ''
      '';
      relatedCategories = [];
    };
    discBurning = {
      name = "discBurning";
      description = ''
      '';
      relatedCategories = [];
    };
    documentation = {
      name = "documentation";
      description = ''
      '';
      relatedCategories = [];
    };
    economy = {
      name = "economy";
      description = ''
      '';
      relatedCategories = [];
    };
    electricity = {
      name = "electricity";
      description = ''
      '';
      relatedCategories = [];
    };
    electronics = {
      name = "electronics";
      description = ''
      '';
      relatedCategories = [];
    };
    email = {
      name = "email";
      description = ''
      '';
      relatedCategories = [];
    };
    emulator = {
      name = "emulator";
      description = ''
      '';
      relatedCategories = [];
    };
    engineering = {
      name = "engineering";
      description = ''
      '';
      relatedCategories = [];
    };
    feed = {
      name = "feed";
      description = ''
      '';
      relatedCategories = [];
    };
    fileManager = {
      name = "fileManager";
      description = ''
      '';
      relatedCategories = [];
    };
    fileTools = {
      name = "fileTools";
      description = ''
      '';
      relatedCategories = [];
    };
    fileTransfer = {
      name = "fileTransfer";
      description = ''
      '';
      relatedCategories = [];
    };
    filesystem = {
      name = "filesystem";
      description = ''
      '';
      relatedCategories = [];
    };
    finance = {
      name = "finance";
      description = ''
      '';
      relatedCategories = [];
    };
    flowChart = {
      name = "flowChart";
      description = ''
      '';
      relatedCategories = [];
    };
    geography = {
      name = "geography";
      description = ''
      '';
      relatedCategories = [];
    };
    geology = {
      name = "geology";
      description = ''
      '';
      relatedCategories = [];
    };
    geoscience = {
      name = "geoscience";
      description = ''
      '';
      relatedCategories = [];
    };
    gnome = {
      name = "gnome";
      description = ''
      '';
      relatedCategories = [];
    };
    gtk = {
      name = "gtk";
      description = ''
      '';
      relatedCategories = [];
    };
    guiDesigner = {
      name = "guiDesigner";
      description = ''
      '';
      relatedCategories = [];
    };
    hamRadio = {
      name = "hamRadio";
      description = ''
      '';
      relatedCategories = [];
    };
    hardwareSettings = {
      name = "hardwareSettings";
      description = ''
      '';
      relatedCategories = [];
    };
    history = {
      name = "history";
      description = ''
      '';
      relatedCategories = [];
    };
    humanities = {
      name = "humanities";
      description = ''
      '';
      relatedCategories = [];
    };
    ide = {
      name = "ide";
      description = ''
      '';
      relatedCategories = [];
    };
    imageProcessing = {
      name = "imageProcessing";
      description = ''
      '';
      relatedCategories = [];
    };
    instantMessaging = {
      name = "instantMessaging";
      description = ''
      '';
      relatedCategories = [];
    };
    ircClient = {
      name = "ircClient";
      description = ''
      '';
      relatedCategories = [];
    };
    java = {
      name = "java";
      description = ''
      '';
      relatedCategories = [];
    };
    kde = {
      name = "kde";
      description = ''
      '';
      relatedCategories = [];
    };
    kidsGame = {
      name = "kidsGame";
      description = ''
      '';
      relatedCategories = [];
    };
    languages = {
      name = "languages";
      description = ''
      '';
      relatedCategories = [];
    };
    literature = {
      name = "literature";
      description = ''
      '';
      relatedCategories = [];
    };
    logicGame = {
      name = "logicGame";
      description = ''
      '';
      relatedCategories = [];
    };
    maps = {
      name = "maps";
      description = ''
      '';
      relatedCategories = [];
    };
    math = {
      name = "math";
      description = ''
      '';
      relatedCategories = [];
    };
    medicalSoftware = {
      name = "medicalSoftware";
      description = ''
      '';
      relatedCategories = [];
    };
    midi = {
      name = "midi";
      description = ''
      '';
      relatedCategories = [];
    };
    mixer = {
      name = "mixer";
      description = ''
      '';
      relatedCategories = [];
    };
    monitor = {
      name = "monitor";
      description = ''
      '';
      relatedCategories = [];
    };
    motif = {
      name = "motif";
      description = ''
      '';
      relatedCategories = [];
    };
    music = {
      name = "music";
      description = ''
      '';
      relatedCategories = [];
    };
    news = {
      name = "news";
      description = ''
      '';
      relatedCategories = [];
    };
    numericalAnalysis = {
      name = "numericalAnalysis";
      description = ''
      '';
      relatedCategories = [];
    };
    ocr = {
      name = "ocr";
      description = ''
      '';
      relatedCategories = [];
    };
    p2p = {
      name = "p2p";
      description = ''
      '';
      relatedCategories = [];
    };
    packageManager = {
      name = "packageManager";
      description = ''
      '';
      relatedCategories = [];
    };
    parallelComputing = {
      name = "parallelComputing";
      description = ''
      '';
      relatedCategories = [];
    };
    pda = {
      name = "pda";
      description = ''
      '';
      relatedCategories = [];
    };
    photography = {
      name = "photography";
      description = ''
      '';
      relatedCategories = [];
    };
    physics = {
      name = "physics";
      description = ''
      '';
      relatedCategories = [];
    };
    player = {
      name = "player";
      description = ''
      '';
      relatedCategories = [];
    };
    presentation = {
      name = "presentation";
      description = ''
      '';
      relatedCategories = [];
    };
    printing = {
      name = "printing";
      description = ''
      '';
      relatedCategories = [];
    };
    profiling = {
      name = "profiling";
      description = ''
      '';
      relatedCategories = [];
    };
    projectManagement = {
      name = "projectManagement";
      description = ''
      '';
      relatedCategories = [];
    };
    publishing = {
      name = "publishing";
      description = ''
      '';
      relatedCategories = [];
    };
    qt = {
      name = "qt";
      description = ''
      '';
      relatedCategories = [];
    };
    rasterGraphics = {
      name = "rasterGraphics";
      description = ''
      '';
      relatedCategories = [];
    };
    recorder = {
      name = "recorder";
      description = ''
      '';
      relatedCategories = [];
    };
    remoteAccess = {
      name = "remoteAccess";
      description = ''
      '';
      relatedCategories = [];
    };
    revisionControl = {
      name = "revisionControl";
      description = ''
      '';
      relatedCategories = [];
    };
    robotics = {
      name = "robotics";
      description = ''
      '';
      relatedCategories = [];
    };
    rolePlaying = {
      name = "rolePlaying";
      description = ''
      '';
      relatedCategories = [];
    };
    scanning = {
      name = "scanning";
      description = ''
      '';
      relatedCategories = [];
    };
    security = {
      name = "security";
      description = ''
      '';
      relatedCategories = [];
    };
    sequencer = {
      name = "sequencer";
      description = ''
      '';
      relatedCategories = [];
    };
    shooter = {
      name = "shooter";
      description = ''
      '';
      relatedCategories = [];
    };
    simulation = {
      name = "simulation";
      description = ''
      '';
      relatedCategories = [];
    };
    spirituality = {
      name = "spirituality";
      description = ''
      '';
      relatedCategories = [];
    };
    sports = {
      name = "sports";
      description = ''
      '';
      relatedCategories = [];
    };
    sportsGame = {
      name = "sportsGame";
      description = ''
      '';
      relatedCategories = [];
    };
    spreadsheet = {
      name = "spreadsheet";
      description = ''
      '';
      relatedCategories = [];
    };
    strategyGame = {
      name = "strategyGame";
      description = ''
      '';
      relatedCategories = [];
    };
    telephony = {
      name = "telephony";
      description = ''
      '';
      relatedCategories = [];
    };
    telephonyTools = {
      name = "telephonyTools";
      description = ''
      '';
      relatedCategories = [];
    };
    terminalEmulator = {
      name = "terminalEmulator";
      description = ''
      '';
      relatedCategories = [];
    };
    textEditor = {
      name = "textEditor";
      description = ''
      '';
      relatedCategories = [];
    };
    textTools = {
      name = "textTools";
      description = ''
      '';
      relatedCategories = [];
    };
    translation = {
      name = "translation";
      description = ''
      '';
      relatedCategories = [];
    };
    tuner = {
      name = "tuner";
      description = ''
      '';
      relatedCategories = [];
    };
    tv = {
      name = "tv";
      description = ''
      '';
      relatedCategories = [];
    };
    vectorGraphics = {
      name = "vectorGraphics";
      description = ''
      '';
      relatedCategories = [];
    };
    videoConference = {
      name = "videoConference";
      description = ''
      '';
      relatedCategories = [];
    };
    viewer = {
      name = "viewer";
      description = ''
      '';
      relatedCategories = [];
    };
    webBrowser = {
      name = "webBrowser";
      description = ''
      '';
      relatedCategories = [];
    };
    webDevelopment = {
      name = "webDevelopment";
      description = ''
      '';
      relatedCategories = [];
    };
    wordProcessor = {
      name = "wordProcessor";
      description = ''
      '';
      relatedCategories = [];
    };
    xfce = {
      name = "xfce";
      description = ''
      '';
      relatedCategories = [];
    };
  };

  reservedCategories = {
    applet = {
      name = "applet";
      description = ''
      '';
      relatedCategories = [];
    };
    screensaver = {
      name = "screensaver";
      description = ''
      '';
      relatedCategories = [];
    };
    shell = {
      name = "shell";
      description = ''
      '';
      relatedCategories = [];
    };
    trayIcon = {
      name = "trayIcon";
      description = ''
      '';
      relatedCategories = [];
    };
  };

  # "Custom" list of categories for the use of Nixpkgs
  nixpkgsAdditionalCategories = {
    software = {
      name = "Software";
      description = ''
        Any piece of software, here understood as a set of data, routines and
        programs associated with the operation of a computer system.

        This category is a catch-all placeholder for situations in which a more
        specific category is not possible or desired - such as automatically
        generated packages.
      '';
      relatedCategories = [ /* Always empty*/ ];
    };
  };

  allCategories = lib.foldl lib.recursiveUpdate {} [
    mainCategories
    additionalCategories
    reservedCategories
    nixpkgsAdditionalCategories
  ];
in
allCategories
