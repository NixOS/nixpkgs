# [License](https://www.debian.org/license):
# This material can be redistributed and/or modified under the terms of the
# MIT (Expat) License or, at your option, of the GNU General Public License;
# either version 2 of the License, or (at your option) any later version
# (the latest version is usually available at
# https://www.gnu.org/licenses/gpl.html).

{
  accessibility = {
    name = "Accessibility Support";
    description = ''
      Accessibility support provided by the package.
    '';

    input = {
      name = "Input Systems";
      description = ''
        Applies to input methods for non-latin languages as well as special input systems.
      '';
    };
    ocr = {
      name = "Text Recognition (OCR)";
      description = ''
        The translation of text images into machine-editable text by means of Optical Character Recognition (OCR).
      '';
    };
    screenMagnify = {
      name = "Screen Magnification";
      description = ''
        Displays enlarged screen content.
      '';
    };
    screenReader = {
      name = "Screen Reading";
      description = ''
        Converts text into speech.
      '';
    };
    speech = {
      name = "Speech Synthesis";
      description = ''
        The artificial production of human speech.
      '';
    };
    speechRecognition = {
      name = "Speech Recognition";
      description = ''
        Converts speech into text.
      '';
    };
  };

  admin = {
    name = "System Administration";
    description = ''
      Which system administration activities the package may perform.
    '';

    accounting = {
      name = "Accounting";
    };
    automation = {
      name = "Automation and Scheduling";
      description = ''
        Automating the execution of software in the system.
      '';
    };
    backup = {
      name = "Backup and Restoration";
    };
    benchmarking = {
      name = "Benchmarking";
    };
    boot = {
      name = "System Boot";
    };
    cluster = {
      name = "Clustering";
    };
    configuring = {
      name = "Configuration Tool";
    };
    fileDistribution = {
      name = "File Distribution";
    };
    filesystem = {
      name = "Filesystem Tool";
      description = ''
        Creation, maintenance, and use of filesystems.
      '';
    };
    forensics = {
      name = "Forensics and Recovery";
      description = ''
        Recovering lost or damaged data.
      '';
    };
    hardware = {
      name = "Hardware Support";
    };
    install = {
      name = "System Installation";
    };
    issuetracker = {
      name = "Issue Tracker";
    };
    kernel = {
      name = "Kernel or Modules";
    };
    logging = {
      name = "Logging";
    };
    login = {
      name = "Login";
      description = ''
        Logging into the system.
      '';
    };
    monitoring = {
      name = "Monitoring";
    };
    packageManagement = {
      name = "Package Management";
    };
    powerManagement = {
      name = "Power Management";
    };
    recovery = {
      name = "Data Recovery";
    };
    userManagement = {
      name = "User Management";
    };
    virtualization = {
      name = "Virtualization";
      description = ''
        This is not hardware emulation, but rather those facilities that allow to create many isolated compartments inside the same system.
      '';
    };
  };

  biology = {
    name = "Biology";
    description = ''
      How the package is related to the field of biology.
    '';

    emboss = {
      name = "EMBOSS";
      description = ''
        Packages related to the European Molecular Biology Open Software Suite.
      '';
    };
    formatAln = {
      name = "Clustal/ALN";
      description = ''
        Used in multiple alignment of biological sequences.
      '';
    };
    formatNexus = {
      name = "Nexus";
      description = ''
        Popular format for phylogenetic trees.
      '';
    };
    nuceleicAcids = {
      name = "Nucleic Acids";
      description = ''
        Software that works with sequences of nucleic acids: DNA, RNA but also non-natural nucleic acids such as PNA or LNA.
      '';
    };
    peptidic = {
      name = "Proteins";
      description = ''
        Software that works with sequences of aminoacids: peptides and proteins.
      '';
    };
  };

  culture = {
    name = "Culture";
    description = ''
      The culture for which the package provides special support.
    '';

    afrikaans = {
      name = "Afrikaans";
    };
    arabic = {
      name = "Arabic";
    };
    basque = {
      name = "Basque";
    };
    bengali = {
      name = "Bengali";
    };
    bokmaal = {
      name = "Norwegian Bokmaal";
    };
    bosnian = {
      name = "Bosnian";
    };
    brazilian = {
      name = "Brazilian";
    };
    british = {
      name = "British";
    };
    bulgarian = {
      name = "Bulgarian";
    };
    catalan = {
      name = "Catalan";
    };
    chinese = {
      name = "Chinese";
    };
    croatian = {
      name = "Croatian";
    };
    czech = {
      name = "Czech";
    };
    danish = {
      name = "Danish";
    };
    dutch = {
      name = "Dutch";
    };
    esperanto = {
      name = "Esperanto";
    };
    estonian = {
      name = "Estonian";
    };
    faroese = {
      name = "Faroese";
    };
    farsi = {
      name = "Farsi";
    };
    finnish = {
      name = "Finnish";
    };
    french = {
      name = "French";
    };
    german = {
      name = "German";
    };
    greek = {
      name = "Greek";
    };
    hebrew = {
      name = "Hebrew";
    };
    hindi = {
      name = "Hindi";
    };
    hungarian = {
      name = "Hungarian";
    };
    icelandic = {
      name = "Icelandic";
    };
    irish = {
      name = "Irish (Gaeilge)";
    };
    italian = {
      name = "Italian";
    };
    japanese = {
      name = "Japanese";
    };
    korean = {
      name = "Korean";
    };
    latvian = {
      name = "Latvian";
    };
    mongolian = {
      name = "Mongolian";
    };
    norwegian = {
      name = "Norwegian";
    };
    nynorsk = {
      name = "Norwegian Nynorsk";
    };
    polish = {
      name = "Polish";
    };
    portuguese = {
      name = "Portuguese";
    };
    punjabi = {
      name = "Punjabi";
    };
    romanian = {
      name = "Romanian";
    };
    russian = {
      name = "Russian";
    };
    serbian = {
      name = "Serbian";
    };
    slovak = {
      name = "Slovak";
    };
    spanish = {
      name = "Spanish";
    };
    swedish = {
      name = "Swedish";
    };
    taiwanese = {
      name = "Taiwanese";
    };
    tajik = {
      name = "Tajik";
    };
    tamil = {
      name = "Tamil";
    };
    thai = {
      name = "Thai";
    };
    turkish = {
      name = "Turkish";
    };
    ukrainian = {
      name = "Ukrainian";
    };
    uzbek = {
      name = "Uzbek";
    };
    welsh = {
      name = "Welsh";
    };
  };

  devel = {
    name = "Software Development";
    description = ''
      How the package is related to the field of software development.
    '';

    bugtracker = {
      name = "Bug Tracking";
    };
    buildtools = {
      name = "Build Tool";
    };
    codeGenerator = {
      name = "Code Generation";
      description = ''
        Parser, lexer and other code generators.
      '';
    };
    compiler = {
      name = "Compiler";
    };
    debian = {
      name = "Debian";
      description = ''
        Tools, documentation, etc. of use primarily to Debian developers.
      '';
    };
    debugger = {
      name = "Debugging";
    };
    docsystem = {
      name = "Literate Programming";
      description = ''
        Tools and auto-documenters.
      '';
    };
    documentation = {
      name = "Documentation";
    };
    ecmaCli = {
      name = "ECMA CLI";
      description = ''
        Tools and libraries for development with implementations of the ECMA CLI (Common Language Infrastructure), like Mono or DotGNU Portable.NET.
      '';
    };
    editor = {
      name = "Source Editor";
    };
    examples = {
      name = "Examples";
    };
    i18n = {
      name = "Internationalization";
    };
    ide = {
      name = "IDE";
      description = ''
        Integrated Development Environment.
      '';
    };
    interpreter = {
      name = "Interpreter";
    };
    langAda = {
      name = "Ada Development";
    };
    langC = {
      name = "C Development";
    };
    langCSharp = {
      name = "C# Development";
    };
    langCPlusPlus = {
      name = "C++ Development";
    };
    langEcmascript = {
      name = "Ecmascript/JavaScript Development";
    };
    langFortran = {
      name = "Fortran Development";
    };
    langHaskell = {
      name = "Haskell Development";
    };
    langJava = {
      name = "Java Development";
    };
    langLisp = {
      name = "Lisp Development";
    };
    langLua = {
      name = "Lua Development";
    };
    langMl = {
      name = "ML Development";
    };
    langObjc = {
      name = "Objective-C Development";
    };
    langOcaml = {
      name = "OCaml Development";
    };
    langOctave = {
      name = "GNU Octave Development";
    };
    langPascal = {
      name = "Pascal Development";
    };
    langPerl = {
      name = "Perl Development";
    };
    langPhp = {
      name = "PHP Development";
    };
    langPike = {
      name = "Pike Development";
    };
    langPosixShell = {
      name = "POSIX shell";
    };
    langProlog = {
      name = "Prolog Development";
    };
    langPython = {
      name = "Python Development";
    };
    langR = {
      name = "GNU R Development";
    };
    langRuby = {
      name = "Ruby Development";
    };
    langScheme = {
      name = "Scheme Development";
    };
    langSql = {
      name = "SQL";
    };
    langTcl = {
      name = "Tcl Development";
    };
    library = {
      name = "Libraries";
    };
    machinecode = {
      name = "Machine Code";
      description = ''
        Assemblers and other machine-code development tools.
      '';
    };
    modelling = {
      name = "Modelling";
      description = ''
        Programs and libraries that support creation of software models with modelling languages like UML or OCL.
      '';
    };
    packaging = {
      name = "Packaging";
      description = ''
        Tools for packaging software.
      '';
    };
    prettyprint = {
      name = "Prettyprint";
      description = ''
        Code pretty-printing and indentation/reformatting.
      '';
    };
    profiler = {
      name = "Profiling";
      description = ''
        Profiling and optimization tools.
      '';
    };
    rcs = {
      name = "Revision Control";
      description = ''
        RCS (Revision Control System) and SCM (Software Configuration Manager).
      '';
    };
    rpc = {
      name = "RPC";
      description = ''
        Remote Procedure Call, Network transparent programming.
      '';
    };
    runtime = {
      name = "Runtime Support";
      description = ''
        Runtime environments of various languages and systems.
      '';
    };
    testingQa = {
      name = "Testing and QA";
      description = ''
        Tools for software testing and quality assurance.
      '';
    };
    uiBuilder = {
      name = "User Interface";
      description = ''
        Tools for designing user interfaces.
      '';
    };
    web = {
      name = "Web";
      description = ''
        Web-centric frameworks, CGI libraries and other web-specific development tools.
      '';
    };
  };

  field = {
    name = "Field";
    description = ''
      Which branch of knowledge is the package related to.
    '';

    arts = {
      name = "Arts";
    };
    astronomy = {
      name = "Astronomy";
    };
    aviation = {
      name = "Aviation";
    };
    biologyBioinformatics = {
      name = "Bioinformatics";
      description = ''
        Sequence analysis software.
      '';
    };
    biologyMolecular = {
      name = "Molecular Biology";
      description = ''
        Software useful to molecular cloning and related wet biology.
      '';
    };
    biologyStructural = {
      name = "Structural Biology";
      description = ''
        Software useful to model tridimensional structures.
      '';
    };
    chemistry = {
      name = "Chemistry";
    };
    electronics = {
      name = "Electronics";
      description = ''
        Circuit editors and other electronics-related software.
      '';
    };
    finance = {
      name = "Financial";
      description = ''
        Accounting and financial software.
      '';
    };
    genealogy = {
      name = "Genealogy";
    };
    geography = {
      name = "Geography";
    };
    geology = {
      name = "Geology";
    };
    linguistics = {
      name = "Linguistics";
    };
    mathematics = {
      name = "Mathematics";
    };
    medicine = {
      name = "Medicine";
    };
    medicineImaging = {
      name = "Medical Imaging";
    };
    meteorology = {
      name = "Meteorology";
    };
    physics = {
      name = "Physics";
    };
    religion = {
      name = "Religion";
    };
    statistics = {
      name = "Statistics";
    };
  };

  game = {
    name = "Games and Amusement";
    description = ''
      Kind of games provided by the package.
    '';

    adventure = {
      name = "Adventure";
    };
    arcade = {
      name = "Action and Arcade";
    };
    board = {
      name = "Board";
    };
    boardChess = {
      name = "Chess";
    };
    card = {
      name = "Card";
    };
    demos = {
      name = "Demo";
    };
    fps = {
      name = "First Person Shooter";
    };
    mud = {
      name = "Multiplayer RPG";
      description = ''
        MUDs, MOOs, and other multiplayer RPGs.
      '';
    };
    platform = {
      name = "Platform";
    };
    puzzle = {
      name = "Puzzle";
    };
    rpg = {
      name = "Role-playing";
    };
    rpgRogue = {
      name = "Rogue-like RPG";
      description = ''
        Games like Nethack, Angband etc.
      '';
    };
    simulation = {
      name = "Simulation";
    };
    sport = {
      name = "Sport Games";
    };
    sportRacing = {
      name = "Racing";
    };
    strategy = {
      name = "Strategy";
    };
    tetris = {
      name = "Tetris-like";
    };
    toys = {
      name = "Toy or Gimmick";
    };
    typing = {
      name = "Typing Tutor";
    };
  };

  hardware = {
    name = "Hardware Enablement";
    description = ''
      How the package is related to hardware enablement.
    '';

    camera = {
      name = "Digital Camera";
    };
    detection = {
      name = "Hardware Detection";
    };
    embedded = {
      name = "Embedded";
    };
    emulation = {
      name = "Emulation";
    };
    gps = {
      name = "GPS";
      description = ''
        Global Positioning System.
      '';
    };
    hamradio = {
      name = "Ham Radio";
    };
    input = {
      name = "Input Devices";
    };
    inputJoystick = {
      name = "Joystick";
    };
    inputKeyboard = {
      name = "Keyboard";
    };
    inputMouse = {
      name = "Mouse";
    };
    joystick = {
      name = "Joystick (legacy)";
    };
    laptop = {
      name = "Laptop";
    };
    modem = {
      name = "Modem";
    };
    modemDsl = {
      name = "xDSL Modem";
    };
    opengl = {
      name = "Requires video hardware acceleration";
    };
    powerAcpi = {
      name = "ACPI Power Management";
    };
    powerApm = {
      name = "APM Power Management";
    };
    powerUps = {
      name = "UPS";
      description = ''
        Uninterruptible Power Supply.
      '';
    };
    printer = {
      name = "Printer";
    };
    scanner = {
      name = "Image-scanning Hardware";
    };
    storage = {
      name = "Storage";
    };
    storageCd = {
      name = "CD";
      description = ''
        Compact Disc.
      '';
    };
    storageDvd = {
      name = "DVD";
      description = ''
        Digital Versatile Disc.
      '';
    };
    storageFloppy = {
      name = "Floppy Disk";
    };
    usb = {
      name = "USB";
      description = ''
        Universal Serial Bus.
      '';
    };
    video = {
      name = "Graphics and Video";
    };
  };

  implementedIn = {
    name = "Implemented in";
    description = ''
      What language the software is implemented in.
    '';

    ada = {
      name = "Ada";
    };
    c = {
      name = "C";
    };
    cSharp = {
      name = "C#";
    };
    cPlusPlus = {
      name = "C++";
    };
    ecmascript = {
      name = "Ecmascript/Javascript";
    };
    fortran = {
      name = "Fortran";
    };
    haskell = {
      name = "Haskell";
    };
    java = {
      name = "Java";
    };
    lisp = {
      name = "Lisp";
    };
    lua = {
      name = "Lua";
    };
    ml = {
      name = "ML";
    };
    objc = {
      name = "Objective C";
    };
    ocaml = {
      name = "OCaml";
    };
    perl = {
      name = "Perl";
    };
    php = {
      name = "PHP";
    };
    pike = {
      name = "Pike";
    };
    python = {
      name = "Python";
    };
    r = {
      name = "GNU R";
    };
    ruby = {
      name = "Ruby";
    };
    scheme = {
      name = "Scheme";
    };
    shell = {
      name = "sh, bash, ksh, tcsh and other shells";
    };
    tcl = {
      name = "Tcl, Tool Command Language";
    };
  };

  interface = {
    name = "User Interface";
    description = ''
      What kind of user interface the package provides.
    '';

    _3d = {
      name = "Three-Dimensional";
    };
    commandline = {
      name = "Command Line";
    };
    daemon = {
      name = "Daemon";
      description = ''
        Runs in background, only a control interface is provided, usually on commandline.
      '';
    };
    framebuffer = {
      name = "Framebuffer";
    };
    shell = {
      name = "Command Shell";
    };
    svga = {
      name = "Console SVGA";
    };
    textMode = {
      name = "Text-based Interactive";
    };
    web = {
      name = "World Wide Web";
    };
    x11 = {
      name = "X Window System";
    };
  };

  iso15924 = {
    name = "Writing script";
    description = ''
      Codes for representating writing systems.
    '';

    armn = {
      name = "Armenian";
    };
    bopo = {
      name = "Bopomofo";
    };
    brai = {
      name = "Braille";
    };
    cans = {
      name = "Unified Canadian Aboriginal Syllabics";
    };
    cyrl = {
      name = "Cyrillic";
    };
    deva = {
      name = "Devanagari (Nagari)";
    };
    ethi = {
      name = "Ethiopic (Geʻez)";
    };
    geor = {
      name = "Georgian (Mkhedruli)";
    };
    gujr = {
      name = "Gujarati";
    };
    guru = {
      name = "Gurmukhi";
    };
    hang = {
      name = "Hangul (Hangŭl, Hangeul)";
    };
    hani = {
      name = "Han (Hanzi, Kanji, Hanja)";
    };
    hans = {
      name = "Han (Simplified variant)";
    };
    hant = {
      name = "Han (Traditional variant)";
    };
    hira = {
      name = "Hiragana";
      description = ''
        Alias for Han + Hiragana + Katakana.
      '';
    };
    kana = {
      name = "Katakana";
    };
    khmr = {
      name = "Khmer";
    };
    knda = {
      name = "Kannada";
      description = ''
        Alias for Hangul + Han.
      '';
    };
    laoo = {
      name = "Lao";
    };
    latn = {
      name = "Latin";
    };
    mlym = {
      name = "Malayalam";
    };
    mymr = {
      name = "Myanmar (Burmese)";
    };
    orya = {
      name = "Oriya";
    };
    sinh = {
      name = "Sinhala";
    };
    syrc = {
      name = "Syriac";
    };
    tavt = {
      name = "Tai Viet";
    };
    telu = {
      name = "Telugu";
    };
    tibt = {
      name = "Tibetan";
    };
    yiii = {
      name = "Yi";
    };
    zsym = {
      name = "Symbols";
    };
  };

  junior = {
    name = "Junior Applications";
    description = ''
      Applications recommended for younger users.
    '';

    arcade = {
      name = "Arcade Games";
    };
    gamesGl = {
      name = "3D Games";
    };
    meta = {
      name = "Metapackages";
    };
  };

  madeOf = {
    name = "Made Of";
    description = ''
      The languages or data formats used to make the package.
    '';

    audio = {
      name = "Audio";
    };
    dictionary = {
      name = "Dictionary";
    };
    font = {
      name = "Font";
    };
    html = {
      name = "HTML, Hypertext Markup Language";
    };
    icons = {
      name = "Icons";
    };
    info = {
      name = "Documentation in Info Format";
    };
    man = {
      name = "Manuals in Nroff Format";
    };
    pdf = {
      name = "PDF Documents";
    };
    postscript = {
      name = "PostScript";
    };
    sgml = {
      name = "SGML, Standard Generalized Markup Language";
    };
    svg = {
      name = "SVG, Scalable Vector Graphics";
    };
    tex = {
      name = "TeX, LaTeX and DVI";
    };
    vrml = {
      name = "VRML, Virtual Reality Markup Language";
    };
    xml = {
      name = "XML";
    };
  };

  mail = {
    name = "Electronic Mail";
    description = ''
      How the package is related to eletronic mail transmission.
    '';

    deliveryAgent = {
      name = "Mail Delivery Agent";
      description = ''
        Software that delivers mail to users' mailboxes.
      '';
    };
    filters = {
      name = "Filters";
    };
    imap = {
      name = "IMAP Protocol";
    };
    list = {
      name = "Mailing Lists";
    };
    notification = {
      name = "Notification";
      description = ''
        Software that notifies users about status of mailbox.
      '';
    };
    pop = {
      name = "POP3 Protocol";
    };
    smtp = {
      name = "SMTP Protocol";
    };
    transportAgent = {
      name = "Mail Transport Agent";
      description = ''
        Software that routes and transmits mail across the system and the network.
      '';
    };
    userAgent = {
      name = "Mail User Agent";
      description = ''
        Software that allows users to access e-mail.
      '';
    };
  };

  network = {
    name = "Networking";
    description = ''
      Role performed concerning computer networks.
    '';

    client = {
      name = "Client";
    };
    hiavailability = {
      name = "High Availability";
    };
    loadBalancing = {
      name = "Load Balancing";
    };
    service = {
      name = "Service";
    };
    vpn = {
      name = "VPN or Tunneling";
    };
  };

  office = {
    name = "Office and business";
    description = ''
      Applications related to office and business activities.
    '';

    finance = {
      name = "Finance";
    };
    groupware = {
      name = "Groupware";
    };
    presentation = {
      name = "Presentation";
    };
    projectManagement = {
      name = "Project Management";
    };
    spreadsheet = {
      name = "Spreadsheet";
    };
  };

  protocol = {
    name = "Network Protocol";
    description = ''
      Which network protocols the package can understand.
    '';

    atm = {
      name = "ATM";
      description = ''
        Asynchronous Transfer Mode, a high speed protocol for communication between computers in a network.
        While ATM is used to implement *DSL networks, it has never gained widespread use as a technology for building local area networks (LANs), for which it was originally intended.
        [Wikipedia](https://en.wikipedia.org/wiki/Asynchronous_Transfer_Mode)
      '';
    };
    bittorrent = {
      name = "BitTorrent";
      description = ''
        BitTorrent is a protocol for peer-to-peer based file distribution over network.
        Although the actual data transport happens between BitTorrent clients, one central node, the so-called trackers, is needed to keep a list of all clients that download or provide the same file.
        [Official site](https://www.bittorrent.com/)
        [Wikipedia](https://en.wikipedia.org/wiki/BitTorrent)
      '';
    };
    corba = {
      name = "CORBA";
      description = ''
        Common Object Request Broker Architecture, a standard for interoperability between programs written in different languages and running on different hardware platforms. CORBA includes a client-server network protocol for distributed computing.
        With this network protocol, CORBA clients on different computers and written in different languages can exchange objects over a CORBA server such as orbit2 or omniORB.
        [Official site](https://www.omg.org/corba/)
      '';
    };
    dbMysql = {
      name = "MySQL";
      description = ''
        Protocol for accessing MySQL database server.
      '';
    };
    dbPsql = {
      name = "PostgreSQL";
      description = ''
        Protocol for accessing PostgreSQL database server.
      '';
    };
    dcc = {
      name = "DCC";
      description = ''
        Direct Client-to-Client (DCC) is an IRC-related sub-protocol enabling peers to interconnect using an IRC server for handshaking in order to exchange files or perform non-relayed chats.
        [Wikipedia](https://en.wikipedia.org/wiki/Direct_Client-to-Client)
      '';
    };
    dhcp = {
      name = "DHCP";
      description = ''
        Dynamic Host Configuration Protocol, a client-server network protocol for automatic assignment of dynamic IP addresses to computers in a TCP/IP network, rather than giving each computer a static IP address.
        [Wikipedia](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc2131.txt)
      '';
    };
    dns = {
      name = "DNS";
      description = ''
        Domain Name System, a protocol to request information associated with domain names (like \"www.debian.org\"), most prominently the IP address. The protocol is used in communication with a DNS server (like BIND).
        For the Internet, there are 13 root DNS servers around the world that keep the addresses of all registered domain names and provide this information to the DNS servers of Internet service providers.
        [Wikipedia](https://en.wikipedia.org/wiki/Domain_Name_System)
      '';
    };
    ethernet = {
      name = "Ethernet";
      description = ''
        Ethernet is the most popular networking technology for creating local area networks (LANs).
        The computers in an Ethernet network communicate over twisted-pair or fibre cables and are identified by their MAC address. Several different types of Ethernet exist, distinguishable by the maximum connection speed. The most widespread types today are 100MBit/s (100BASE-*) or 1GBit/s (1000BASE-*).
        [Wikipedia](https://en.wikipedia.org/wiki/Ethernet)
      '';
    };
    finger = {
      name = "Finger";
      description = ''
        The Name/Finger protocol is a simple network protocol to provide extensive, public information about users of a computer, such as email address, telephone numbers, full names etc.
        Due to privacy concerns, the Finger protocol is not widely used any more, while it widespread distribution in the early 1990s.
        [Wikipedia](https://en.wikipedia.org/wiki/Finger_protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc1288.txt)
      '';
    };
    ftp = {
      name = "FTP";
      description = ''
        File Transfer Protocol, a protocol for exchanging and manipulation files over networks and extensively used on the Internet.
        The communication between FTP servers and clients uses two channels, the control and the data channel. While FTP was originally used with authentication only, most FTP servers on the Internet provide anonymous, passwordless access. Since FTP does not support encryption, sensitive data transfer is carried out over SFTP today.
        [Wikipedia](https://en.wikipedia.org/wiki/File_Transfer_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc0959.txt)
      '';
    };
    gaduGadu = {
      name = "Gadu-Gadu";
      description = ''
        The Gadu-Gadu protocol is a proprietary protocol that is used by a Polish instant messaging network of the same name.
        [Wikipedia](https://en.wikipedia.org/wiki/Gadu-Gadu)
      '';
    };
    http = {
      name = "HTTP";
      description = ''
        HyperText Transfer Protocol, one of the most important protocols for the World Wide Web.
        It controls the data transfer between HTTP servers such as Apache and HTTP clients, which are web browsers in most cases. HTTP resources are requested via URLs (Universal Resource Locators). While HTTP normally only supports file transfer from server to client, the protocol supports sending information to HTTP servers, most prominently used in HTML forms.
        [Wikipedia](https://en.wikipedia.org/wiki/Http)
        [RFC](https://www.rfc-editor.org/rfc/rfc2616.txt)
      '';
    };
    ident = {
      name = "Ident";
      description = ''
        The Ident Internet protocol helps to identify or authenticate the user of a network connection.
        [Wikipedia](https://en.wikipedia.org/wiki/Ident)
      '';
    };
    imap = {
      name = "IMAP";
      description = ''
        Internet Message Access Protocol, a protocol used for accessing email on a server from a email client such as KMail or Evolution.
        When using IMAP, emails stay on the server and can be categorized, edited, deleted etc. there, instead of having the user download all messages onto the local computer, as POP3 does.
        [Wikipedia](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol)
      '';
    };
    ip = {
      name = "IP";
      description = ''
        Internet Protocol (v4), a core protocol of the Internet protocol suite and the very basis of the Internet.
        Every computer that is connected to the Internet has an IP address (a 4-byte number, typically represented in dotted notation like 192.25.206.10). Internet IP addresses are given out by the Internet Corporation for Assigned Names and Numbers (ICANN). Normally, computers on the Internet are not accessed by their IP address, but by their domain name.
        [Wikipedia](https://en.wikipedia.org/wiki/IPv4)
        [RFC](https://www.rfc-editor.org/rfc/rfc791.txt)
      '';
    };
    ipv6 = {
      name = "IPv6";
      description = ''
        Internet Protocol (v6), the next-generation Internet protocol, which overcomes the restrictions of IP (v4), like shortage of IP addresses, and is supposed to form the new basis of the Internet in the future, replacing IP (v4).
        Many programs already support IPv6 along with IP (v4), although it is still seldomly used.
        [Wikipedia](https://en.wikipedia.org/wiki/IPv6)
        [Official site](https://www.worldipv6launch.org/)
      '';
    };
    irc = {
      name = "IRC";
      description = ''
        Internet Relay Chat, a protocol for text chatting over network, extensively used on the Internet. It supports chat rooms, so-called channels, as well as private, one-to-one communication.
        IRC servers are organized in networks, so that a client can connect to a geographically near IRC server, that itself is connected to other IRC servers spread over the whole world.
        The official Debian channel is #debian on the freenode network.
        [Wikipedia](https://en.wikipedia.org/wiki/Internet_Relay_Chat)
      '';
    };
    jabber = {
      name = "Jabber";
      description = ''
        The Jabber protocol is an instant messaging protocol on the basis of the XMPP protocol. Additionally to private one-to-one communication, it also supports chat rooms, and it is used in the Jabber IM network as well as for the IM capabilities for the new GoogleTalk network.
        In contrast to other IM networks like MSN, ICQ or AIM, the Jabber servers are free software and can be used to create a private chat platform or have an own server to connect to the Jabber network.
        [Official site](https://jabber.org/)
        [Wikipedia](https://en.wikipedia.org/wiki/Jabber)
      '';
    };
    kerberos = {
      name = "Kerberos";
      description = ''
        Kerberos is an authentication protocol for computer networks for secure authentication over an otherwise insecure network, using symmetric cryptography and a third party service provider, that is trusted both by client and server.
        The authentication mechanism provided by Kerberos is mutual, so that not only a server can be sure of a client's identity, but also a client can be sure a connection to a server is not intercepted.
        [Wikipedia](https://en.wikipedia.org/wiki/Kerberos_%28protocol%29)
        [RFC](https://www.rfc-editor.org/rfc/rfc4120.txt)
      '';
    };
    ldap = {
      name = "LDAP";
      description = ''
        Lightweight Directory Access Protocol.
      '';
    };
    lpr = {
      name = "LPR";
      description = ''
        The Line Printer Daemon protocol, a protocol used for accessing or providing network print services in a Unix network, but also used for local setups.
        CUPS, the Common Unix Printing System, was developed to replace the old LPD/LPR system, while maintaining backwards compatibility.
        [Wikipedia](https://en.wikipedia.org/wiki/Line_Printer_Daemon_protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc1179.txt)
      '';
    };
    nfs = {
      name = "NFS";
      description = ''
        Network File System, a protocol originally developed by Sun Microsystems in 1984 and defined in RFCs 1094, 1813, and 3530 (obsoletes 3010) as a distributed file system, allows a user on a client computer to access files over a network as easily as if attached to its local disks.
        [Wikipedia](https://en.wikipedia.org/wiki/Network_File_System)
      '';
    };
    nntp = {
      name = "NNTP";
      description = ''
        Network News Transfer Protocol, a protocol for reading and writing Usenet articles (a Usenet article is comparable with an email), but also used among NNTP servers to transfer articles.
        [Wikipedia](https://en.wikipedia.org/wiki/Network_News_Transfer_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc977.txt)
      '';
    };
    pop3 = {
      name = "POP3";
      description = ''
        Post Office Protocol, a protocol to download emails from a mail server, designed for users that have only intermittent connection to the Internet.
        In contrast to IMAP server, messages that are downloaded via POP3 are not supposed to stay on the server afterwards, since POP3 does not support multiple mailboxes for one account on the server.
        [Wikipedia](https://en.wikipedia.org/wiki/Post_Office_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc1939.txt)
      '';
    };
    radius = {
      name = "RADIUS";
      description = ''
        Remote Authentication Dial In User Service, a protocol for authentication, authorization and accounting of network access, mostly used by Internet service providers to handle dial-up Internet connections.
        [Wikipedia](https://en.wikipedia.org/wiki/RADIUS)
        [RFC](https://www.rfc-editor.org/rfc/rfc2865.txt)
      '';
    };
    sftp = {
      name = "SFTP";
      description = ''
        SSH File Transfer Protocol, a protocol for secure, encrypting file exchange and manipulation over insecure networks, using the SSH protocol.
        SFTP provides a complete set of file system operations, different from its predecessor SCP, which only allows file transfer. It is not, other than the name might suggest, a version of the FTP protocol executed through an SSH channel.
        [Wikipedia](https://en.wikipedia.org/wiki/SSH_file_transfer_protocol)
      '';
    };
    smb = {
      name = "SMB";
      description = ''
        Server Message Block, a protocol for providing file access and printer sharing over network, mainly used by Microsoft Windows(tm). CIFS (Common Internet File System) is a synonym for SMB.
        Although SMB is a proprietary protocol, the Samba project reverse-engineered the protocol and developed both client and server programs for better interoperability in mixed Unix/Windows networks.
        [Wikipedia](https://en.wikipedia.org/wiki/Server_Message_Block)
        [Official site](https://www.samba.org/)
      '';
    };
    smtp = {
      name = "SMTP";
      description = ''
        Simple Mail Transfer Protocol, a protocol for transmitting emails over the Internet.
        Every SMTP server utilizes SMTP to hand on emails to the next mail server until an email arrives at its destination, from where it is usually retrieved via POP3 or IMAP.
        [Wikipedia](https://en.wikipedia.org/wiki/Simple_Mail_Transfer_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc2821.txt)
      '';
    };
    snmp = {
      name = "SNMP";
      description = ''
        Simple Network Management Protocol, a member of the Internet protocol suite and used for monitoring or configuring network devices.
        SNMP servers normally run on network equipment like routers.
        [Wikipedia](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc3411.txt)
      '';
    };
    soap = {
      name = "SOAP";
      description = ''
        Simple Object Access Protocol, a protocol for exchanging messages between different computers in a network. The messages are encoded in XML and usually sent over HTTP.
        SOAP is used to provide APIs to web services, such as the Google API to utilize Google's searching engine from client applications.
        [Wikipedia](https://en.wikipedia.org/wiki/SOAP)
        [Official site](https://www.w3.org/TR/soap/)
      '';
    };
    ssh = {
      name = "SSH";
      description = ''
        Secure Shell, a protocol for secure, encrypted network connections. SSH can be used to execute programs on a remote host with an SSH server over otherwise insecure protocols through an SSH channel. The main use is, as the name suggest, to provide encrypted login and shell access on remote servers.
        SSH authentication can be done with password or, which is the preferred mechanism, via asymmetric public/private key cryptography.
        [Wikipedia](https://en.wikipedia.org/wiki/Secure_Shell)
      '';
    };
    ssl = {
      name = "SSL/TLS";
      description = ''
        Secure Socket Layer/Transport Layer Security, a protocol that provides secure encrypted communication on the Internet. It is used to authenticate the identity of a service provider (such as a Internet banking server) and to secure the communications channel.
        Otherwise insecure protocols such as FTP, HTTP, IMAP or SMTP can be transmitted over SSL/TLS to secure the transmitted data. In this case, an \"S\" is added to the protocol name, like HTTPS, FTPS etc.
        [Wikipedia](https://en.wikipedia.org/wiki/Secure_Sockets_Layer)
      '';
    };
    tcp = {
      name = "TCP";
      description = ''
        Transport Control Protocol, a core protocol of the Internet protocol suite and used for data transport.
        TCP is used as the transport protocol for many services on the Internet, such as FTP, HTTP, SMTP, POP3, IMAP, NNTP etc.
        [Wikipedia](https://en.wikipedia.org/wiki/Transmission_Control_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc793.txt)
      '';
    };
    telnet = {
      name = "Telnet";
      description = ''
        TELecommunication NETwork, a mostly superseded protocol for remote logins.
        [Wikipedia](https://en.wikipedia.org/wiki/TELNET)
      '';
    };
    tftp = {
      name = "TFTP";
      description = ''
        Trivial File Transfer Protocol, a simple file transfer protocol. TFTP allows a client to get or put a file onto a remote host. One of its primary uses is the network booting of diskless nodes on a Local Area Network. It is designed to be easy to implement so it fits on ROM.
        [Wikipedia](https://en.wikipedia.org/wiki/Trivial_File_Transfer_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc1350.txt)
      '';
    };
    udp = {
      name = "UDP";
      description = ''
        User Datagram Protocol, a core protocol of the Internet protocol suite and used for data transport.
        UDP is not as reliable as TCP, but faster and thus better fit for time-sensitive purposes, like the DNS protocol and VoIP.
        [Wikipedia](https://en.wikipedia.org/wiki/User_Datagram_Protocol)
        [RFC](https://www.rfc-editor.org/rfc/rfc768.txt)
      '';
    };
    voip = {
      name = "VoIP";
      description = ''
        Voice over IP, a general term for protocols that route voice conversations over the Internet.
        Popular VoIP protocols are SIP, H.323 and IAX.
        [Wikipedia](https://en.wikipedia.org/wiki/Voice_over_IP)
      '';
    };
    webdav = {
      name = "WebDAV";
      description = ''
        Web-based Distributed Authoring and Versioning, a extension of the HTTP protocol to support creating and changing documents on an HTTP server. Thus, the client can access the documents on an HTTP server as it would those on the local file system.
        [Wikipedia](https://en.wikipedia.org/wiki/WebDAV)
        [RFC](https://www.rfc-editor.org/rfc/rfc2518.txt)
      '';
    };
    xmlrpc = {
      name = "XML-RPC";
      description = ''
        XML Remote Procedure Call, a simple protocol for remote procedure calls that uses XML for encoding and the HTTP protocol for transport.
        SOAP, which is a considerably more sophisticated protocol, was developed from XML-RPC.
        [Wikipedia](https://en.wikipedia.org/wiki/XML-RPC)
        [Offical site](https://xmlrpc.com/)
      '';
    };
    zeroconf = {
      name = "Zeroconf";
      description = ''
        Zero Configuration Networking (Zeroconfig), is a set of techniques that automatically creates a usable IP network without configuration or special servers.
        This tag is used for packages that implement one or more of:
        * IPv4LL for choosing addresses.
        * mDNS for name resolution.
        * DNS-SD for service discovery.
        [Official site](https://www.zeroconf.org/)
        [Wikipedia](https://en.wikipedia.org/wiki/Zeroconf)
      '';
    };
  };

  role = {
    name = "Role";
    description = ''
      Role performed by the package.
    '';

    appData = {
      name = "Application Data";
    };
    data = {
      name = "Standalone Data";
    };
    debugSymbols = {
      name = "Debugging symbols";
      description = ''
        Debugging symbols.
      '';
    };
    develLib = {
      name = "Development Library";
      description = ''
        Library and header files used in software development or building.
      '';
    };
    dummy = {
      name = "Dummy Package";
      description = ''
        Packages used for upgrades and transitions.
      '';
    };
    kernel = {
      name = "Kernel and Modules";
      description = ''
        Packages that contain only operating system kernels and kernel modules.
      '';
    };
    metapackage = {
      name = "Metapackage";
      description = ''
        Packages that install suites of other packages.
      '';
    };
    plugin = {
      name = "Plugin";
      description = ''
        Add-on, pluggable program fragments enhancing functionality of some program or system.
      '';
    };
    program = {
      name = "Program";
      description = ''
        Executable computer program.
      '';
    };
    sharedLib = {
      name = "Shared Library";
      description = ''
        Shared libraries used by one or more programs.
      '';
    };
    source = {
      name = "Source Code";
      description = ''
        Human-readable code of a program, library or a part thereof.
      '';
    };
  };

  science = {
    name = "Science";
    description = ''
      How the package is related to the field of science.
    '';

    bibliography = {
      name = "Bibliography";
    };
    calculation = {
      name = "Calculation";
    };
    dataAcquisition = {
      name = "Data acquisition";
    };
    plotting = {
      name = "Plotting";
    };
    publishing = {
      name = "Publishing";
    };
    visualisation = {
      name = "Visualization";
    };
  };

  scope = {
    name = "Scope";
    description = ''
      Characterization by scale of coverage.
    '';

    application = {
      name = "Application";
      description = ''
        Broad-scoped program for general use. It probably has functionality for 80-90% of use cases. The pieces that remain are usually to be found as utilities.
      '';
    };
    suite = {
      name = "Suite";
      description = ''
        Comprehensive suite of applications and utilities on the scale of desktop environment or base operating system.
      '';
    };
    utility = {
      name = "Utility";
      description = ''
        A narrow-scoped program for particular use case or few use cases. It only does something 10-20% of users in the field will need. Often has functionality missing from related applications.
      '';
    };
  };

  security = {
    name = "Security";
    description = ''
      How the package is related to system security.
    '';

    antivirus = {
      name = "Anti-Virus";
    };
    authentication = {
      name = "Authentication";
    };
    cryptography = {
      name = "Cryptography";
      description = ''
        Cryptographic and privacy-oriented tools.
      '';
    };
    firewall = {
      name = "Firewall";
    };
    forensics = {
      name = "Forensics";
      description = ''
        Post-mortem analysis of intrusions.
      '';
    };
    ids = {
      name = "Intrusion Detection";
    };
    integrity = {
      name = "File Integrity";
      description = ''
        Tools to monitor system for changes in filesystem and report changes or tools providing other means to check system integrity.
      '';
    };
    logAnalyzer = {
      name = "Log Analyzer";
    };
    privacy = {
      name = "Privacy";
    };
  };

  sound = {
    name = "Sound and Music";
    description = ''
      How the package is related to the field of sound and music.
    '';

    compression = {
      name = "Compression";
    };
    midi = {
      name = "MIDI Software";
    };
    mixer = {
      name = "Mixing";
    };
    player = {
      name = "Playback";
    };
    recorder = {
      name = "Recording";
    };
    sequencer = {
      name = "MIDI Sequencing";
    };
  };

  suite = {
    name = "Application Suite";
    description = ''
      Groups together related packages.
    '';

    apache = {
      name = "Apache";
    };
    bsd = {
      name = "BSD";
      description = ''
        Berkeley Software Distribution, sometimes called Berkeley Unix or BSD Unix, and its family of descendants: FreeBSD, NetBSD or OpenBSD.
        [Wikipedia](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution)
      '';
    };
    debian = {
      name = "Debian";
      description = ''
        Packages specific to Debian - look into `devel.Debian` for Debian Development.
      '';
    };
    eclipse = {
      name = "Eclipse";
      description = ''
        Eclipse tool platform and plugins.
      '';
    };
    emacs = {
      name = "Emacs";
    };
    gforge = {
      name = "GForge";
      description = ''
        A collaborative development platform.
      '';
    };
    gimp = {
      name = "The GIMP";
    };
    gkrellm = {
      name = "GKrellM Monitors";
    };
    gnome = {
      name = "GNOME";
    };
    gnu = {
      name = "GNU";
      description = ''
        Gnu's Not Unix. The package is part of the official GNU project.
      '';
    };
    gnustep = {
      name = "GNUstep";
      description = ''
        GNUstep Desktop and WindowMaker.
      '';
    };
    gpe = {
      name = "GPE";
      description = ''
        GPE Palmtop Environment.
      '';
    };
    kde = {
      name = "KDE";
    };
    mozilla = {
      name = "Mozilla";
      description = ''
        Mozilla Browser and extensions.
      '';
    };
    netscape = {
      name = "Netscape Navigator";
      description = ''
        The pre-6.0 versions of netscape browser.
      '';
    };
    openoffice = {
      name = "OpenOffice.org";
    };
    opie = {
      name = "Open Palmtop (OPIE)";
    };
    roxen = {
      name = "Roxen";
    };
    samba = {
      name = "Samba";
    };
    webmin = {
      name = "Webmin";
    };
    xfce = {
      name = "XFce";
      description = ''
        Lightweight desktop environment for X11.
      '';
    };
    xmms = {
      name = "XMMS";
    };
    xmms2 = {
      name = "XMMS 2";
    };
    zope = {
      name = "Zope";
      description = ''
        The Zope (web) publishing platform.
      '';
    };
  };

  uitoolkit = {
    name = "Interface Toolkit";
    description = ''
      Which interface toolkit the package provides.
    '';

    athena = {
      name = "Athena Widgets";
    };
    fltk = {
      name = "FLTK";
    };
    glut = {
      name = "GLUT";
    };
    gtk = {
      name = "GTK";
    };
    motif = {
      name = "Lesstif/Motif";
    };
    ncurses = {
      name = "Ncurses TUI";
    };
    qt = {
      name = "Qt";
    };
    sdl = {
      name = "SDL";
    };
    tk = {
      name = "Tk";
    };
    wxwidgets = {
      name = "wxWidgets";
    };
    xlib = {
      name = "X library";
    };
  };

  use = {
    name = "Purpose";
    description = ''
      The general purpose of the software.
    '';

    analysing = {
      name = "Analysing";
      description = ''
        Software for turning data into knowledge.
      '';
    };
    browsing = {
      name = "Browsing";
    };
    calculating = {
      name = "Calculating";
    };
    chatting = {
      name = "Chatting";
    };
    checking = {
      name = "Checking";
      description = ''
        All sorts of checking, checking a filesystem for validity, checking a document for incorrectly spelled words, checking a network for routing problems. Verifying.
      '';
    };
    comparing = {
      name = "Comparing";
      description = ''
        To find what relates or differs in two or more objects.
      '';
    };
    compressing = {
      name = "Compressing";
    };
    configuring = {
      name = "Configuration";
    };
    converting = {
      name = "Data Conversion";
    };
    dialing = {
      name = "Dialup Access";
    };
    downloading = {
      name = "Downloading";
    };
    driver = {
      name = "Hardware Driver";
    };
    editing = {
      name = "Editing";
    };
    entertaining = {
      name = "Entertaining";
    };
    filtering = {
      name = "Filtering";
    };
    gameplaying = {
      name = "Game Playing";
    };
    learning = {
      name = "Learning";
    };
    measuring = {
      name = "Measuring";
    };
    organizing = {
      name = "Data Organisation";
    };
    playing = {
      name = "Playing Media";
    };
    printing = {
      name = "Printing";
    };
    proxying = {
      name = "Proxying";
    };
    routing = {
      name = "Routing";
    };
    scanning = {
      name = "Scanning";
    };
    searching = {
      name = "Searching";
    };
    simulating = {
      name = "Simulating";
    };
    storing = {
      name = "Storing";
    };
    synchronizing = {
      name = "Synchronisation";
    };
    textFormatting = {
      name = "Text Formatting";
    };
    timekeeping = {
      name = "Time and Clock";
    };
    transmission = {
      name = "Transmission";
    };
    typesetting = {
      name = "Typesetting";
    };
    viewing = {
      name = "Data Visualization";
    };
  };

  web = {
    name = "World Wide Web";
    description = ''
      What kind of tools for the World Wide Web the package provides.
    '';

    appserver = {
      name = "Application Server";
    };
    blog = {
      name = "Blog Software";
    };
    browser = {
      name = "Browser";
    };
    cgi = {
      name = "CGI";
    };
    cms = {
      name = "Content Management (CMS)";
    };
    commerce = {
      name = "E-commerce";
    };
    forum = {
      name = "Forum";
    };
    portal = {
      name = "Portal";
    };
    scripting = {
      name = "Scripting";
    };
    searchEngine = {
      name = "Search Engine";
    };
    server = {
      name = "Server";
    };
    wiki = {
      name = "Wiki Software";
      description = ''
        Wiki software, servers, utilities and plug-ins.
      '';
    };
  };

  worksWith = {
    name = "Works with";
    description = ''
      What kind of data (or even processes, or people) the package can work with.
    '';

    _3dmodel = {
      name = "3D Model";
    };
    archive = {
      name = "Archive";
    };
    biologicalSequence = {
      name = "Biological Sequence";
    };
    bugs = {
      name = "Bugs or Issues";
    };
    db = {
      name = "Databases";
    };
    dictionary = {
      name = "Dictionaries";
    };
    dtp = {
      name = "Desktop Publishing (DTP)";
    };
    fax = {
      name = "Faxes";
    };
    file = {
      name = "Files";
    };
    font = {
      name = "Fonts";
    };
    graphs = {
      name = "Trees and Graphs";
    };
    im = {
      name = "Instant Messages";
      description = ''
        The package can connect to some IM network (or networks).
      '';
    };
    image = {
      name = "Image";
    };
    imageRaster = {
      name = "Raster Image";
      description = ''
        Images made of dots, such as photos and scans.
      '';
    };
    imageVector = {
      name = "Vector Image";
      description = ''
        Images made of lines, such as graphs or most clipart.
      '';
    };
    logfile = {
      name = "System Logs";
    };
    mail = {
      name = "Email";
    };
    musicNotation = {
      name = "Music Notation";
    };
    networkTraffic = {
      name = "Network Traffic";
      description = ''
        Routers, shapers, sniffers, firewalls and other tools that work with a stream of network packets.
      '';
    };
    people = {
      name = "People";
    };
    pim = {
      name = "Personal Information";
    };
    softwarePackage = {
      name = "Packaged Software";
    };
    softwareRunning = {
      name = "Running Programs";
    };
    softwareSource = {
      name = "Source Code";
    };
    text = {
      name = "Text";
    };
    unicode = {
      name = "Unicode";
      description = ''
        Please do not tag programs with simple unicode support, doing so would make this tag useless. Ultimately all applications should have unicode support.
      '';
    };
    vcs = {
      name = "Version control system";
    };
    video = {
      name = "Video and Animation";
    };
  };

  worksWithFormat = {
    name = "Supports Format";
    description = ''
      Which data formats are supported by the package.
    '';

    bib = {
      name = "BibTeX";
      description = ''
        BibTeX list of references.
      '';
    };
    djvu = {
      name = "DjVu";
      description = ''
        File format to store scanned documents.
        [Wikipedia](https://en.wikipedia.org/wiki/Djvu)
      '';
    };
    docbook = {
      name = "DocBook";
    };
    dvi = {
      name = "TeX DVI";
      description = ''
        DeVice Independent page description file, usually generated by TeX or LaTeX.
      '';
    };
    gif = {
      name = "GIF, Graphics Interchange Format";
    };
    iso9660 = {
      name = "ISO 9660 CD Filesystem";
    };
    jpg = {
      name = "JPEG, Joint Photographic Experts Group";
    };
    json = {
      name = "JSON";
      description = ''
        JavaScript Object Notation.
      '';
    };
    ldif = {
      name = "LDIF";
      description = ''
        Lightweight Directory Interchange Format.
      '';
    };
    man = {
      name = "Manpages";
    };
    mp3 = {
      name = "MP3 Audio";
    };
    mpc = {
      name = "Musepack Audio";
    };
    odf = {
      name = "ODF, Open Document Format";
    };
    oggtheora = {
      name = "Ogg Theora Video";
    };
    oggvorbis = {
      name = "Ogg Vorbis Audio";
    };
    plaintext = {
      name = "Plain Text";
    };
    png = {
      name = "PNG, Portable Network Graphics";
    };
    swf = {
      name = "SWF, ShockWave Flash";
    };
    tar = {
      name = "Tar Archives";
    };
    tex = {
      name = "TeX and LaTeX";
    };
    tiff = {
      name = "TIFF, Tagged Image File Format";
    };
    vrml = {
      name = "VRML 3D Model";
      description = ''
        Virtual Reality Markup Language.
      '';
    };
    wav = {
      name = "MS RIFF Audio";
      description = ''
        Wave uncompressed audio format.
      '';
    };
    xmlGpx = {
      name = "GPX, GPS eXchange Format";
    };
    xmlRss = {
      name = "RSS Rich Site Summary";
      description = ''
        XML dialect used to describe resources and websites.
      '';
    };
    xmlXslt = {
      name = "XSL Transformations (XSLT)";
    };
    zip = {
      name = "Zip Archives";
    };
  };

  x11 = {
    name = "X Window System";
    description = ''
      How the package is related to the X Window System.
    '';

    applet = {
      name = "Applet";
    };
    displayManager = {
      name = "Login Manager";
      description = ''
        Display managers (graphical login screens).
      '';
    };
    library = {
      name = "Library";
    };
    screensaver = {
      name = "Screen Saver";
    };
    terminal = {
      name = "Terminal Emulator";
    };
    theme = {
      name = "Theme";
    };
    windowManager = {
      name = "Window Manager";
    };
    xserver = {
      name = "X Server and Drivers";
      description = ''
        X servers and drivers for the X server (input and video).
      '';
    };
  };
}
