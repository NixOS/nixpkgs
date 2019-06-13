/* List of NixOS maintainers.

    handle = {
      # Required
      name = "Your name";
      email = "address@example.org";

      # Optional
      github = "GithubUsername";
      keys = [{
        longkeyid = "rsa2048/0x0123456789ABCDEF";
        fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333";
      }];
    };

  where

  - `handle` is the handle you are going to use in nixpkgs expressions,
  - `name` is your, preferably real, name,
  - `email` is your maintainer email address, and
  - `github` is your GitHub handle (as it appears in the URL of your profile page, `https://github.com/<userhandle>`),
  - `keys` is a list of your PGP/GPG key IDs and fingerprints.

  `handle == github` is strongly preferred whenever `github` is an acceptable attribute name and is short and convenient.

  Add PGP/GPG keys only if you actually use them to sign commits and/or mail.

  To get the required PGP/GPG values for a key run
  ```shell
  gpg --keyid-format 0xlong --fingerprint <email> | head -n 2
  ```

  !!! Note that PGP/GPG values stored here are for informational purposes only, don't use this file as a source of truth.

  More fields may be added in the future.

  Please keep the list alphabetically sorted.
  See `./scripts/check-maintainer-github-handles.sh` for an example on how to work with this data.
  */
{
  "0x4A6F" = {
    email = "0x4A6F@shackspace.de";
    name = "Joachim Ernst";
    github = "0x4A6F";
    keys = [{
      longkeyid = "rsa8192/0x87027528B006D66D";
      fingerprint = "F466 A548 AD3F C1F1 8C88  4576 8702 7528 B006 D66D";
    }];
  };
  "1000101" = {
    email = "jan.hrnko@satoshilabs.com";
    github = "1000101";
    name = "Jan Hrnko";
  };
  a1russell = {
    email = "adamlr6+pub@gmail.com";
    github = "a1russell";
    name = "Adam Russell";
  };
  aanderse = {
    email = "aaron@fosslib.net";
    github = "aanderse";
    name = "Aaron Andersen";
  };
  aaronjanse = {
    email = "aaron@ajanse.me";
    github = "aaronjanse";
    name = "Aaron Janse";
    keys = [
      { longkeyid = "rsa2048/0x651BD4B37D75E234"; # Email only
        fingerprint = "490F 5009 34E7 20BD 4C53  96C2 651B D4B3 7D75 E234";
      }
      { longkeyid = "rsa4096/0xBE6C92145BFF4A34"; # Git, etc
        fingerprint = "CED9 6DF4 63D7 B86A 1C4B  1322 BE6C 9214 5BFF 4A34";
      }
    ];
  };
  aaronschif = {
    email = "aaronschif@gmail.com";
    github = "aaronschif";
    name = "Aaron Schif";
  };
  abaldeau = {
    email = "andreas@baldeau.net";
    github = "baldo";
    name = "Andreas Baldeau";
  };
  abbradar = {
    email = "ab@fmap.me";
    github = "abbradar";
    name = "Nikolay Amiantov";
  };
  abhi18av = {
    email = "abhi18av@gmail.com";
    github = "abhi18av";
    name = "Abhinav Sharma";
  };
  abigailbuccaneer = {
    email = "abigailbuccaneer@gmail.com";
    github = "abigailbuccaneer";
    name = "Abigail Bunyan";
  };
  aborsu = {
    email = "a.borsu@gmail.com";
    github = "aborsu";
    name = "Augustin Borsu";
  };
  aboseley = {
    email = "adam.boseley@gmail.com";
    github = "aboseley";
    name = "Adam Boseley";
  };
  abuibrahim = {
    email = "ruslan@babayev.com";
    github = "abuibrahim";
    name = "Ruslan Babayev";
  };
  acowley = {
    email = "acowley@gmail.com";
    github = "acowley";
    name = "Anthony Cowley";
  };
  adamt = {
    email = "mail@adamtulinius.dk";
    github = "adamtulinius";
    name = "Adam Tulinius";
  };
  adelbertc = {
    email = "adelbertc@gmail.com";
    github = "adelbertc";
    name = "Adelbert Chang";
  };
  adev = {
    email = "adev@adev.name";
    github = "adevress";
    name = "Adrien Devresse";
  };
  adisbladis = {
    email = "adis@blad.is";
    github = "adisbladis";
    name = "Adam Hose";
  };
  Adjective-Object = {
    email = "mhuan13@gmail.com";
    github = "Adjective-Object";
    name = "Maxwell Huang-Hobbs";
  };
  adnelson = {
    email = "ithinkican@gmail.com";
    github = "adnelson";
    name = "Allen Nelson";
  };
  adolfogc = {
    email = "adolfo.garcia.cr@gmail.com";
    github = "adolfogc";
    name = "Adolfo E. García Castro";
  };
  aepsil0n = {
    email = "eduard.bopp@aepsil0n.de";
    github = "aepsil0n";
    name = "Eduard Bopp";
  };
  aerialx = {
    email = "aaron+nixos@aaronlindsay.com";
    github = "AerialX";
    name = "Aaron Lindsay";
  };
  aespinosa = {
    email = "allan.espinosa@outlook.com";
    github = "aespinosa";
    name = "Allan Espinosa";
  };
  aethelz = {
    email = "aethelz@protonmail.com";
    github = "aethelz";
    name = "Eugene";
  };
  aflatter = {
    email = "flatter@fastmail.fm";
    github = "aflatter";
    name = "Alexander Flatter";
  };
  afldcr = {
    email = "alex@fldcr.com";
    github = "afldcr";
    name = "James Alexander Feldman-Crough";
  };
  aforemny = {
    email = "alexanderforemny@googlemail.com";
    github = "aforemny";
    name = "Alexander Foremny";
  };
  afranchuk = {
    email = "alex.franchuk@gmail.com";
    github = "afranchuk";
    name = "Alex Franchuk";
  };
  aherrmann = {
    email = "andreash87@gmx.ch";
    github = "aherrmann";
    name = "Andreas Herrmann";
  };
  ahmedtd = {
    email = "ahmed.taahir@gmail.com";
    github = "ahmedtd";
    name = "Taahir Ahmed";
  };
  ahuzik = {
    email = "ales.guzik@gmail.com";
    github = "alesguzik";
    name = "Ales Huzik";
  };
  aij = {
    email = "aij+git@mrph.org";
    github = "aij";
    name = "Ivan Jager";
  };
  ajs124 = {
    email = "nix@ajs124.de";
    github = "ajs124";
    name = "Andreas Schrägle";
  };
  ajgrf = {
    email = "a@ajgrf.com";
    github = "ajgrf";
    name = "Alex Griffin";
  };
  ak = {
    email = "ak@formalprivacy.com";
    github = "alexanderkjeldaas";
    name = "Alexander Kjeldaas";
  };
  akavel = {
    email = "czapkofan@gmail.com";
    github = "akavel";
    name = "Mateusz Czapliński";
  };
  akaWolf = {
    email = "akawolf0@gmail.com";
    github = "akaWolf";
    name = "Artjom Vejsel";
  };
  akc = {
    email = "akc@akc.is";
    github = "akc";
    name = "Anders Claesson";
  };
  akru = {
    email = "mail@akru.me";
    github = "akru";
    name = "Alexander Krupenkin ";
  };
  alexchapman = {
    email = "alex@farfromthere.net";
    github = "AJChapman";
    name = "Alex Chapman";
  };
  alexfmpe = {
    email = "alexandre.fmp.esteves@gmail.com";
    github = "alexfmpe";
    name = "Alexandre Esteves";
  };
  alexvorobiev = {
    email = "alexander.vorobiev@gmail.com";
    github = "alexvorobiev";
    name = "Alex Vorobiev";
  };
  algorith = {
    email = "dries_van_daele@telenet.be";
    name = "Dries Van Daele";
  };
  alibabzo = {
    email = "alistair.bill@gmail.com";
    github = "alibabzo";
    name = "Alistair Bill";
  };
  all = {
    email = "nix-commits@lists.science.uu.nl";
    name = "Nix Committers";
  };
  allonsy = {
    email = "linuxbash8@gmail.com";
    github = "allonsy";
    name = "Alec Snyder";
  };
  alunduil = {
    email = "alunduil@gmail.com";
    github = "alunduil";
    name = "Alex Brandt";
  };
  amar1729 = {
    email = "amar.paul16@gmail.com";
    github = "amar1729";
    name = "Amar Paul";
  };
  ambrop72 = {
    email = "ambrop7@gmail.com";
    github = "ambrop72";
    name = "Ambroz Bizjak";
  };
  amiddelk = {
    email = "amiddelk@gmail.com";
    github = "amiddelk";
    name = "Arie Middelkoop";
  };
  amiloradovsky = {
    email = "miloradovsky@gmail.com";
    github = "amiloradovsky";
    name = "Andrew Miloradovsky";
  };
  aminb = {
    email = "amin@aminb.org";
    github = "aminb";
    name = "Amin Bandali";
  };
  aminechikhaoui = {
    email = "amine.chikhaoui91@gmail.com";
    github = "AmineChikhaoui";
    name = "Amine Chikhaoui";
  };
  amorsillo = {
    email = "andrew.morsillo@gmail.com";
    github = "AndrewMorsillo";
    name = "Andrew Morsillo";
  };
  andersk = {
    email = "andersk@mit.edu";
    github = "andersk";
    name = "Anders Kaseorg";
  };
  AndersonTorres = {
    email = "torres.anderson.85@protonmail.com";
    github = "AndersonTorres";
    name = "Anderson Torres";
  };
  anderspapitto = {
    email = "anderspapitto@gmail.com";
    github = "anderspapitto";
    name = "Anders Papitto";
  };
  andir = {
    email = "andreas@rammhold.de";
    github = "andir";
    name = "Andreas Rammhold";
  };
  andreabedini = {
    email = "andrea@kzn.io";
    github = "andreabedini";
    name = "Andrea Bedini";
  };
  andres = {
    email = "ksnixos@andres-loeh.de";
    github = "kosmikus";
    name = "Andres Loeh";
  };
  andrestylianos = {
    email = "andre.stylianos@gmail.com";
    github = "andrestylianos";
    name = "Andre S. Ramos";
  };
  andrew-d = {
    email = "andrew@du.nham.ca";
    github = "andrew-d";
    name = "Andrew Dunham";
  };
  andrewchambers = {
    email = "ac@acha.ninja";
    github = "andrewchambers";
    name = "Andrew Chambers";
  };
  andrewrk = {
    email = "superjoe30@gmail.com";
    github = "andrewrk";
    name = "Andrew Kelley";
  };
  andsild = {
    email = "andsild@gmail.com";
    github = "andsild";
    name = "Anders Sildnes";
  };
  aneeshusa = {
    email = "aneeshusa@gmail.com";
    github = "aneeshusa";
    name = "Aneesh Agrawal";
  };
  ankhers = {
    email = "justin.k.wood@gmail.com";
    github = "ankhers";
    name = "Justin Wood";
  };
  anpryl = {
    email = "anpryl@gmail.com";
    github = "anpryl";
    name = "Anatolii Prylutskyi";
  };
  anton-dessiatov = {
    email = "anton.dessiatov@gmail.com";
    github = "anton-dessiatov";
    name = "Anton Desyatov";
  };
  Anton-Latukha = {
    email = "anton.latuka+nixpkgs@gmail.com";
    github = "Anton-Latukha";
    name = "Anton Latukha";
  };
  antono = {
    email = "self@antono.info";
    github = "antono";
    name = "Antono Vasiljev";
  };
  antonxy = {
    email = "anton.schirg@posteo.de";
    github = "antonxy";
    name = "Anton Schirg";
  };
  apeschar = {
    email = "albert@peschar.net";
    github = "apeschar";
    name = "Albert Peschar";
  };
  apeyroux = {
    email = "alex@px.io";
    github = "apeyroux";
    name = "Alexandre Peyroux";
  };
  ar1a = {
    email = "aria@ar1as.space";
    github = "ar1a";
    name = "Aria Edmonds";
  };
  arcadio = {
    email = "arc@well.ox.ac.uk";
    github = "arcadio";
    name = "Arcadio Rubio García";
  };
  ardumont = {
    email = "eniotna.t@gmail.com";
    github = "ardumont";
    name = "Antoine R. Dumont";
  };
  aristid = {
    email = "aristidb@gmail.com";
    github = "aristidb";
    name = "Aristid Breitkreuz";
  };
  ariutta = {
    email = "anders.riutta@gmail.com";
    github = "ariutta";
    name = "Anders Riutta";
  };
  arobyn = {
    email = "shados@shados.net";
    github = "shados";
    name = "Alexei Robyn";
  };
  artemist = {
    email = "me@artem.ist";
    github = "artemist";
    name = "Artemis Tosini";
    keys = [{
      longkeyid = "rsa4096/0x4FDC96F161E7BA8A";
      fingerprint = "3D2B B230 F9FA F0C5 1832  46DD 4FDC 96F1 61E7 BA8A";
    }];
  };
  artuuge = {
    email = "artuuge@gmail.com";
    github = "artuuge";
    name = "Artur E. Ruuge";
  };
  ashalkhakov = {
    email = "artyom.shalkhakov@gmail.com";
    github = "ashalkhakov";
    name = "Artyom Shalkhakov";
  };
  ashgillman = {
    email = "gillmanash@gmail.com";
    github = "ashgillman";
    name = "Ashley Gillman";
  };
  aske = {
    email = "aske@fmap.me";
    github = "aske";
    name = "Kirill Boltaev";
  };
  asppsa = {
    email = "asppsa@gmail.com";
    github = "asppsa";
    name = "Alastair Pharo";
  };
  astro = {
    email = "astro@spaceboyz.net";
    github = "astro";
    name = "Astro";
  };
  astsmtl = {
    email = "astsmtl@yandex.ru";
    github = "astsmtl";
    name = "Alexander Tsamutali";
  };
  asymmetric = {
    email = "lorenzo@mailbox.org";
    github = "asymmetric";
    name = "Lorenzo Manacorda";
  };
  aszlig = {
    email = "aszlig@nix.build";
    github = "aszlig";
    name = "aszlig";
  };
  atnnn = {
    email = "etienne@atnnn.com";
    github = "atnnn";
    name = "Etienne Laurin";
  };
  auntie = {
    email = "auntieNeo@gmail.com";
    github = "auntie";
    name = "Jonathan Glines";
  };
  avaq = {
    email = "avaq+nixos@xs4all.nl";
    github = "avaq";
    name = "Aldwin Vlasblom";
  };
  avery = {
    email = "averyl+nixos@protonmail.com";
    github = "AveryLychee";
    name = "Avery Lychee";
  };
  averelld = {
    email = "averell+nixos@rxd4.com";
    github = "averelld";
    name = "averelld";
  };
  avnik = {
    email = "avn@avnik.info";
    github = "avnik";
    name = "Alexander V. Nikolaev";
  };
  aw = {
    email = "aw-nixos@meterriblecrew.net";
    github = "herrwiese";
    name = "Andreas Wiese";
  };
  aycanirican = {
    email = "iricanaycan@gmail.com";
    github = "aycanirican";
    name = "Aycan iRiCAN";
  };
  babariviere = {
    email = "babariviere@protonmail.com";
    github = "babariviere";
    name = "babariviere";
  };
  bachp = {
    email = "pascal.bach@nextrem.ch";
    github = "bachp";
    name = "Pascal Bach";
  };
  backuitist = {
    email = "biethb@gmail.com";
    github = "backuitist";
    name = "Bruno Bieth";
  };
  badi = {
    email = "abdulwahidc@gmail.com";
    github = "badi";
    name = "Badi' Abdul-Wahid";
  };
  balajisivaraman = {
    email = "sivaraman.balaji@gmail.com";
    name = "Balaji Sivaraman";
  };
  balsoft = {
    email = "balsoft75@gmail.com";
    github = "balsoft";
    name = "Alexander Bantyev";
  };
  bandresen = {
    email = "bandresen@gmail.com";
    github = "bandresen";
    name = "Benjamin Andresen";
  };
  baracoder = {
    email = "baracoder@googlemail.com";
    github = "baracoder";
    name = "Herman Fries";
  };
  barrucadu = {
    email = "mike@barrucadu.co.uk";
    github = "barrucadu";
    name = "Michael Walker";
  };
  basvandijk = {
    email = "v.dijk.bas@gmail.com";
    github = "basvandijk";
    name = "Bas van Dijk";
  };
  Baughn = {
    email = "sveina@gmail.com";
    github = "Baughn";
    name = "Svein Ove Aas";
  };
  bb010g = {
    email = "me@bb010g.com";
    github = "bb010g";
    name = "Brayden Banks";
  };
  bbarker = {
    email = "brandon.barker@gmail.com";
    github = "bbarker";
    name = "Brandon Elam Barker";
  };
  bbigras = {
    email = "bigras.bruno@gmail.com";
    github = "bbigras";
    name = "Bruno Bigras";
  };
  bcarrell = {
    email = "brandoncarrell@gmail.com";
    github = "bcarrell";
    name = "Brandon Carrell";
  };
  bcdarwin = {
    email = "bcdarwin@gmail.com";
    github = "bcdarwin";
    name = "Ben Darwin";
  };
  bdesham = {
    email = "benjamin@esham.io";
    github = "bdesham";
    name = "Benjamin Esham";
  };
  bdimcheff = {
    email = "brandon@dimcheff.com";
    github = "bdimcheff";
    name = "Brandon Dimcheff";
  };
  bendlas = {
    email = "herwig@bendlas.net";
    github = "bendlas";
    name = "Herwig Hochleitner";
  };
  benley = {
    email = "benley@gmail.com";
    github = "benley";
    name = "Benjamin Staffin";
  };
  bennofs = {
    email = "benno.fuenfstueck@gmail.com";
    github = "bennofs";
    name = "Benno Fünfstück";
  };
  benpye = {
    email = "ben@curlybracket.co.uk";
    github = "benpye";
    name = "Ben Pye";
  };
  benwbooth = {
    email = "benwbooth@gmail.com";
    github = "benwbooth";
    name = "Ben Booth";
  };
  berce = {
    email = "bert.moens@gmail.com";
    github = "berce";
    name = "Bert Moens";
  };
  berdario = {
    email = "berdario@gmail.com";
    github = "berdario";
    name = "Dario Bertini";
  };
  bergey = {
    email = "bergey@teallabs.org";
    github = "bergey";
    name = "Daniel Bergey";
  };
  bfortz = {
    email = "bernard.fortz@gmail.com";
    github = "bfortz";
    name = "Bernard Fortz";
  };
  bgamari = {
    email = "ben@smart-cactus.org";
    github = "bgamari";
    name = "Ben Gamari";
  };
  bhall = {
    email = "brendan.j.hall@bath.edu";
    github = "brendan-hall";
    name = "Brendan Hall";
  };
  bhipple = {
    email = "bhipple@protonmail.com";
    github = "bhipple";
    name = "Benjamin Hipple";
  };
  binarin = {
    email = "binarin@binarin.ru";
    github = "binarin";
    name = "Alexey Lebedeff";
  };
  bjg = {
    email = "bjg@gnu.org";
    name = "Brian Gough";
  };
  bjornfor = {
    email = "bjorn.forsman@gmail.com";
    github = "bjornfor";
    name = "Bjørn Forsman";
  };
  bkchr = {
    email = "nixos@kchr.de";
    github = "bkchr";
    name = "Bastian Köcher";
  };
  bluescreen303 = {
    email = "mathijs@bluescreen303.nl";
    github = "bluescreen303";
    name = "Mathijs Kwik";
  };
  bobakker = {
    email = "bobakk3r@gmail.com";
    github = "bobakker";
    name = "Bo Bakker";
  };
  bobvanderlinden = {
    email = "bobvanderlinden@gmail.com";
    github = "bobvanderlinden";
    name = "Bob van der Linden";
  };
  bodil = {
    email = "nix@bodil.org";
    github = "bodil";
    name = "Bodil Stokke";
  };
  boj = {
    email = "brian@uncannyworks.com";
    github = "boj";
    name = "Brian Jones";
  };
  boothead = {
    email = "ben@perurbis.com";
    github = "boothead";
    name = "Ben Ford";
  };
  borisbabic = {
    email = "boris.ivan.babic@gmail.com";
    github = "borisbabic";
    name = "Boris Babić";
  };
  bosu = {
    email = "boriss@gmail.com";
    github = "bosu";
    name = "Boris Sukholitko";
  };
  bradediger = {
    email = "brad@bradediger.com";
    github = "bradediger";
    name = "Brad Ediger";
  };
  brainrape = {
    email = "martonboros@gmail.com";
    github = "brainrape";
    name = "Marton Boros";
  };
  bramd = {
    email = "bram@bramd.nl";
    github = "bramd";
    name = "Bram Duvigneau";
  };
  braydenjw = {
    email = "nixpkgs@willenborg.ca";
    github = "braydenjw";
    name = "Brayden Willenborg";
  };
  brian-dawn = {
    email = "brian.t.dawn@gmail.com";
    github = "brian-dawn";
    name = "Brian Dawn";
  };
  brianhicks = {
    email = "brian@brianthicks.com";
    github = "BrianHicks";
    name = "Brian Hicks";
  };
  bricewge = {
    email = "bricewge@gmail.com";
    github = "bricewge";
    name = "Brice Waegeneire";
  };
  bstrik = {
    email = "dutchman55@gmx.com";
    github = "bstrik";
    name = "Berno Strik";
  };
  buffet = {
    email = "niclas@countingsort.com";
    github = "buffet";
    name = "Niclas Meyer";
  };
  bugworm = {
    email = "bugworm@zoho.com";
    github = "bugworm";
    name = "Roman Gerasimenko";
  };
  bzizou = {
    email = "Bruno@bzizou.net";
    github = "bzizou";
    name = "Bruno Bzeznik";
  };
  c0bw3b = {
    email = "c0bw3b@gmail.com";
    github = "c0bw3b";
    name = "Renaud";
  };
  c0deaddict = {
    email = "josvanbakel@protonmail.com";
    github = "c0deaddict";
    name = "Jos van Bakel";
  };
  calbrecht = {
    email = "christian.albrecht@mayflower.de";
    github = "calbrecht";
    name = "Christian Albrecht";
  };
  callahad = {
    email = "dan.callahan@gmail.com";
    github = "callahad";
    name = "Dan Callahan";
  };
  calvertvl = {
    email = "calvertvl@gmail.com";
    github = "calvertvl";
    name = "Victor Calvert";
  };
  campadrenalin = {
    email = "campadrenalin@gmail.com";
    github = "campadrenalin";
    name = "Philip Horger";
  };
  candeira = {
    email = "javier@candeira.com";
    github = "candeira";
    name = "Javier Candeira";
  };
  canndrew = {
    email = "shum@canndrew.org";
    github = "canndrew";
    name = "Andrew Cann";
  };
  carlosdagos = {
    email = "m@cdagostino.io";
    github = "carlosdagos";
    name = "Carlos D'Agostino";
  };
  carlsverre = {
    email = "accounts@carlsverre.com";
    github = "carlsverre";
    name = "Carl Sverre";
  };
  cartr = {
    email = "carter.sande@duodecima.technology";
    github = "cartr";
    name = "Carter Sande";
  };
  casey = {
    email = "casey@rodarmor.net";
    github = "casey";
    name = "Casey Rodarmor";
  };
  catern = {
    email = "sbaugh@catern.com";
    github = "catern";
    name = "Spencer Baugh";
  };
  caugner = {
    email = "nixos@caugner.de";
    github = "caugner";
    name = "Claas Augner";
  };
  cbley = {
    email = "claudio.bley@gmail.com";
    github = "avdv";
    name = "Claudio Bley";
  };
  cdepillabout = {
    email = "cdep.illabout@gmail.com";
    github = "cdepillabout";
    name = "Dennis Gosnell";
  };
  ceedubs = {
    email = "ceedubs@gmail.com";
    github = "ceedubs";
    name = "Cody Allen";
  };
  cf6b88f = {
    email = "elmo.todurov@eesti.ee";
    github = "cf6b88f";
    name = "Elmo Todurov";
  };
  cfouche = {
    email = "chaddai.fouche@gmail.com";
    github = "Chaddai";
    name = "Chaddaï Fouché";
  };
  chaduffy = {
    email = "charles@dyfis.net";
    github = "charles-dyfis-net";
    name = "Charles Duffy";
  };
  changlinli = {
    email = "mail@changlinli.com";
    github = "changlinli";
    name = "Changlin Li";
  };
  CharlesHD = {
    email = "charleshdespointes@gmail.com";
    github = "CharlesHD";
    name = "Charles Huyghues-Despointes";
  };
  chaoflow = {
    email = "flo@chaoflow.net";
    github = "chaoflow";
    name = "Florian Friesdorf";
  };
  chattered = {
    email = "me@philscotted.com";
    name = "Phil Scott";
  };
  ChengCat = {
    email = "yu@cheng.cat";
    github = "ChengCat";
    name = "Yucheng Zhang";
  };
  chessai = {
    email = "chessai1996@gmail.com";
    github = "chessai";
    name = "Daniel Cartwright";
  };
  chiiruno = {
    email = "okinan@protonmail.com";
    github = "chiiruno";
    name = "Okina Matara";
  };
  choochootrain = {
    email = "hurshal@imap.cc";
    github = "choochootrain";
    name = "Hurshal Patel";
  };
  chpatrick = {
    email = "chpatrick@gmail.com";
    github = "chpatrick";
    name = "Patrick Chilton";
  };
  chreekat = {
    email = "b@chreekat.net";
    github = "chreekat";
    name = "Bryan Richter";
  };
  chris-martin = {
    email = "ch.martin@gmail.com";
    github = "chris-martin";
    name = "Chris Martin";
  };
  chrisaw = {
    email = "home@chrisaw.com";
    github = "cawilliamson";
    name = "Christopher A. Williamson";
  };
  chrisjefferson = {
    email = "chris@bubblescope.net";
    github = "chrisjefferson";
    name = "Christopher Jefferson";
  };
  chrisrosset = {
    email = "chris@rosset.org.uk";
    github = "chrisrosset";
    name = "Christopher Rosset";
  };
  christopherpoole = {
    email = "mail@christopherpoole.net";
    github = "christopherpoole";
    name = "Christopher Mark Poole";
  };
  ciil = {
    email = "simon@lackerbauer.com";
    github = "ciil";
    name = "Simon Lackerbauer";
  };
  ck3d = {
    email = "ck3d@gmx.de";
    github = "ck3d";
    name = "Christian Kögler";
  };
  ckampka = {
    email = "christian@kampka.net";
    github = "kampka";
    name = "Christian Kampka";
  };
  ckauhaus = {
    email = "kc@flyingcircus.io";
    github = "ckauhaus";
    name = "Christian Kauhaus";
  };
  cko = {
    email = "christine.koppelt@gmail.com";
    github = "cko";
    name = "Christine Koppelt";
  };
  clacke = {
    email = "claes.wallin@greatsinodevelopment.com";
    github = "clacke";
    name = "Claes Wallin";
  };
  cleverca22 = {
    email = "cleverca22@gmail.com";
    github = "cleverca22";
    name = "Michael Bishop";
  };
  cmcdragonkai = {
    email = "roger.qiu@matrix.ai";
    github = "cmcdragonkai";
    name = "Roger Qiu";
  };
  cmfwyp = {
    email = "cmfwyp@riseup.net";
    github = "cmfwyp";
    name = "cmfwyp";
  };
  cobbal = {
    email = "andrew.cobb@gmail.com";
    github = "cobbal";
    name = "Andrew Cobb";
  };
  coconnor = {
    email = "coreyoconnor@gmail.com";
    github = "coreyoconnor";
    name = "Corey O'Connor";
  };
  codsl = {
    email = "codsl@riseup.net";
    github = "codsl";
    name = "codsl";
  };
  codyopel = {
    email = "codyopel@gmail.com";
    github = "codyopel";
    name = "Cody Opel";
  };
  colemickens = {
    email = "cole.mickens@gmail.com";
    github = "colemickens";
    name = "Cole Mickens";
  };
  colescott = {
    email = "colescottsf@gmail.com";
    github = "colescott";
    name = "Cole Scott";
  };
  copumpkin = {
    email = "pumpkingod@gmail.com";
    github = "copumpkin";
    name = "Dan Peebles";
  };
  corngood = {
    email = "corngood@gmail.com";
    github = "corngood";
    name = "David McFarland";
  };
  coroa = {
    email = "jonas@chaoflow.net";
    github = "coroa";
    name = "Jonas Hörsch";
  };
  costrouc = {
    email = "chris.ostrouchov@gmail.com";
    github = "costrouc";
    name = "Chris Ostrouchov";
  };
  couchemar = {
    email = "couchemar@yandex.ru";
    github = "couchemar";
    name = "Andrey Pavlov";
  };
  cpages = {
    email = "page@ruiec.cat";
    github = "cpages";
    name = "Carles Pagès";
  };
  cransom = {
    email = "cransom@hubns.net";
    github = "cransom";
    name = "Casey Ransom";
  };
  CrazedProgrammer = {
    email = "crazedprogrammer@gmail.com";
    github = "CrazedProgrammer";
    name = "CrazedProgrammer";
  };
  cryptix = {
    email = "cryptix@riseup.net";
    github = "cryptix";
    name = "Henry Bubert";
  };
  CrystalGamma = {
    email = "nixos@crystalgamma.de";
    github = "CrystalGamma";
    name = "Jona Stubbe";
  };
  csingley = {
    email = "csingley@gmail.com";
    github = "csingley";
    name = "Christopher Singley";
  };
  cstrahan = {
    email = "charles@cstrahan.com";
    github = "cstrahan";
    name = "Charles Strahan";
  };
  cwoac = {
    email = "oliver@codersoffortune.net";
    github = "cwoac";
    name = "Oliver Matthews";
  };
  dalance = {
    email = "dalance@gmail.com";
    github = "dalance";
    name = "Naoya Hatta";
  };
  DamienCassou = {
    email = "damien@cassou.me";
    github = "DamienCassou";
    name = "Damien Cassou";
  };
  danbst = {
    email = "abcz2.uprola@gmail.com";
    github = "danbst";
    name = "Danylo Hlynskyi";
  };
  dancek = {
    email = "hannu.hartikainen@gmail.com";
    github = "dancek";
    name = "Hannu Hartikainen";
  };
  danharaj = {
    email = "dan@obsidian.systems";
    github = "danharaj";
    name = "Dan Haraj";
  };
  danieldk = {
    email = "me@danieldk.eu";
    github = "danieldk";
    name = "Daniël de Kok";
  };
  danielfullmer = {
    email = "danielrf12@gmail.com";
    github = "danielfullmer";
    name = "Daniel Fullmer";
  };
  das-g = {
    email = "nixpkgs@raphael.dasgupta.ch";
    github = "das-g";
    name = "Raphael Das Gupta";
  };
  das_j = {
    email = "janne@hess.ooo";
    github = "dasJ";
    name = "Janne Heß";
  };
  dasuxullebt = {
    email = "christoph.senjak@googlemail.com";
    name = "Christoph-Simon Senjak";
  };
  david50407 = {
    email = "me@davy.tw";
    github = "david50407";
    name = "David Kuo";
  };
  davidak = {
    email = "post@davidak.de";
    github = "davidak";
    name = "David Kleuker";
  };
  davidrusu = {
    email = "davidrusu.me@gmail.com";
    github = "davidrusu";
    name = "David Rusu";
  };
  davorb = {
    email = "davor@davor.se";
    github = "davorb";
    name = "Davor Babic";
  };
  dawidsowa = {
    email = "dawid_sowa@posteo.net";
    github = "dawidsowa";
    name = "Dawid Sowa";
  };
  dbohdan = {
    email = "dbohdan@dbohdan.com";
    github = "dbohdan";
    name = "D. Bohdan";
  };
  dbrock = {
    email = "daniel@brockman.se";
    github = "dbrock";
    name = "Daniel Brockman";
  };
  deepfire = {
    email = "_deepfire@feelingofgreen.ru";
    github = "deepfire";
    name = "Kosyrev Serge";
  };
  delroth = {
    email = "delroth@gmail.com";
    github = "delroth";
    name = "Pierre Bourdon";
  };
  deltaevo = {
    email = "deltaduartedavid@gmail.com";
    github = "DeltaEvo";
    name = "Duarte David";
  };
  demin-dmitriy = {
    email = "demindf@gmail.com";
    github = "demin-dmitriy";
    name = "Dmitriy Demin";
  };
  demize = {
    email = "johannes@kyriasis.com";
    github = "kyrias";
    name = "Johannes Löthberg";
  };
  demyanrogozhin = {
    email = "demyan.rogozhin@gmail.com";
    github = "demyanrogozhin";
    name = "Demyan Rogozhin";
  };
  derchris = {
    email = "derchris@me.com";
    github = "derchrisuk";
    name = "Christian Gerbrandt";
  };
  DerGuteMoritz = {
    email = "moritz@twoticketsplease.de";
    github = "DerGuteMoritz";
    name = "Moritz Heidkamp";
  };
  dermetfan = {
    email = "serverkorken@gmail.com";
    github = "dermetfan";
    name = "Robin Stumm";
  };
  DerTim1 = {
    email = "tim.digel@active-group.de";
    github = "DerTim1";
    name = "Tim Digel";
  };
  desiderius = {
    email = "didier@devroye.name";
    github = "desiderius";
    name = "Didier J. Devroye";
  };
  devhell = {
    email = "\"^\"@regexmail.net";
    github = "devhell";
    name = "devhell";
  };
  dezgeg = {
    email = "tuomas.tynkkynen@iki.fi";
    github = "dezgeg";
    name = "Tuomas Tynkkynen";
  };
  dfordivam = {
    email = "dfordivam+nixpkgs@gmail.com";
    github = "dfordivam";
    name = "Divam";
  };
  dfoxfranke = {
    email = "dfoxfranke@gmail.com";
    github = "dfoxfranke";
    name = "Daniel Fox Franke";
  };
  dgonyeo = {
    email = "derek@gonyeo.com";
    github = "dgonyeo";
    name = "Derek Gonyeo";
  };
  dhkl = {
    email = "david@davidslab.com";
    github = "dhl";
    name = "David Leung";
  };
  dipinhora = {
    email = "dipinhora+github@gmail.com";
    github = "dipinhora";
    name = "Dipin Hora";
  };
  disassembler = {
    email = "disasm@gmail.com";
    github = "disassembler";
    name = "Samuel Leathers";
  };
  disserman = {
    email = "disserman@gmail.com";
    github = "divi255";
    name = "Sergei S.";
  };
  dizfer = {
    email = "david@izquierdofernandez.com";
    github = "dizfer";
    name = "David Izquierdo";
  };
  Dje4321 = {
    email = "dje4321@gmail.com";
    github = "dje4321";
    name = "Dje4321";
  };
  dmalikov = {
    email = "malikov.d.y@gmail.com";
    github = "dmalikov";
    name = "Dmitry Malikov";
  };
  DmitryTsygankov = {
    email = "dmitry.tsygankov@gmail.com";
    github = "DmitryTsygankov";
    name = "Dmitry Tsygankov";
  };
  dmjio = {
    email = "djohnson.m@gmail.com";
    github = "dmjio";
    name = "David Johnson";
  };
  dochang = {
    email = "dochang@gmail.com";
    github = "dochang";
    name = "Desmond O. Chang";
  };
  domenkozar = {
    email = "domen@dev.si";
    github = "domenkozar";
    name = "Domen Kozar";
  };
  dotlambda = {
    email = "rschuetz17@gmail.com";
    github = "dotlambda";
    name = "Robert Schütz";
  };
  doublec = {
    email = "chris.double@double.co.nz";
    github = "doublec";
    name = "Chris Double";
  };
  dpaetzel = {
    email = "david.a.paetzel@gmail.com";
    github = "dpaetzel";
    name = "David Pätzel";
  };
  dpflug = {
    email = "david@pflug.email";
    github = "dpflug";
    name = "David Pflug";
  };
  drets = {
    email = "dmitryrets@gmail.com";
    github = "drets";
    name = "Dmytro Rets";
  };
  drewkett = {
    email = "burkett.andrew@gmail.com";
    name = "Andrew Burkett";
  };
  dsferruzza = {
    email = "david.sferruzza@gmail.com";
    github = "dsferruzza";
    name = "David Sferruzza";
  };
  dtzWill = {
    email = "w@wdtz.org";
    github = "dtzWill";
    name = "Will Dietz";
    keys = [{
      longkeyid = "rsa4096/0xFD42C7D0D41494C8";
      fingerprint = "389A 78CB CD88 5E0C 4701  DEB9 FD42 C7D0 D414 94C8";
    }];
  };
  dxf = {
    email = "dingxiangfei2009@gmail.com";
    github = "dingxiangfei2009";
    name = "Ding Xiang Fei";
  };
  dysinger = {
    email = "tim@dysinger.net";
    github = "dysinger";
    name = "Tim Dysinger";
  };
  dywedir = {
    email = "dywedir@gra.red";
    github = "dywedir";
    name = "Vladyslav M.";
  };
  dzabraev = {
    email = "dzabraew@gmail.com";
    github = "dzabraev";
    name = "Maksim Dzabraev";
  };
  e-user = {
    email = "nixos@sodosopa.io";
    github = "e-user";
    name = "Alexander Kahl";
  };
  eadwu = {
    email = "edmund.wu@protonmail.com";
    github = "eadwu";
    name = "Edmund Wu";
  };
  eamsden = {
    email = "edward@blackriversoft.com";
    github = "eamsden";
    name = "Edward Amsden";
  };
  earldouglas = {
    email = "james@earldouglas.com";
    github = "earldouglas";
    name = "James Earl Douglas";
  };
  earvstedt = {
    email = "erik.arvstedt@gmail.com";
    github = "erikarvstedt";
    name = "Erik Arvstedt";
  };
  ebzzry = {
    email = "ebzzry@ebzzry.io";
    github = "ebzzry";
    name = "Rommel Martinez";
  };
  edanaher = {
    email = "nixos@edanaher.net";
    github = "edanaher";
    name = "Evan Danaher";
  };
  edef = {
    email = "edef@edef.eu";
    github = "edef1c";
    name = "edef";
  };
  embr = {
    email = "hi@liclac.eu";
    github = "liclac";
    name = "embr";
  };
  ederoyd46 = {
    email = "matt@ederoyd.co.uk";
    github = "ederoyd46";
    name = "Matthew Brown";
  };
  eduarrrd = {
    email = "e.bachmakov@gmail.com";
    github = "eduarrrd";
    name = "Eduard Bachmakov";
  };
  edude03 = {
    email = "michael@melenion.com";
    github = "edude03";
    name = "Michael Francis";
  };
  edwtjo = {
    email = "ed@cflags.cc";
    github = "edwtjo";
    name = "Edward Tjörnhammar";
  };
  eelco = {
    email = "eelco.dolstra@logicblox.com";
    github = "edolstra";
    name = "Eelco Dolstra";
  };
  ehegnes = {
    email = "eric.hegnes@gmail.com";
    github = "ehegnes";
    name = "Eric Hegnes";
  };
  ehmry = {
    email = "emery@vfemail.net";
    name = "Emery Hemingway";
  };
  eikek = {
    email = "eike.kettner@posteo.de";
    github = "eikek";
    name = "Eike Kettner";
  };
  ekleog = {
    email = "leo@gaspard.io";
    github = "ekleog";
    name = "Leo Gaspard";
  };
  elasticdog = {
    email = "aaron@elasticdog.com";
    github = "elasticdog";
    name = "Aaron Bull Schaefer";
  };
  eleanor = {
    email = "dejan@proteansec.com";
    github = "proteansec";
    name = "Dejan Lukan";
  };
  eliasp = {
    email = "mail@eliasprobst.eu";
    github = "eliasp";
    name = "Elias Probst";
  };
  elijahcaine = {
    email = "elijahcainemv@gmail.com";
    github = "pop";
    name = "Elijah Caine";
  };
  elitak = {
    email = "elitak@gmail.com";
    github = "elitak";
    name = "Eric Litak";
  };
  ellis = {
    email = "nixos@ellisw.net";
    github = "ellis";
    name = "Ellis Whitehead";
  };
  elohmeier = {
    email = "elo-nixos@nerdworks.de";
    github = "elohmeier";
    name = "Enno Lohmeier";
  };
  elseym = {
    email = "elseym@me.com";
    github = "elseym";
    name = "Simon Waibl";
  };
  elvishjerricco = {
    email = "elvishjerricco@gmail.com";
    github = "ElvishJerricco";
    name = "Will Fancher";
  };
  emmanuelrosa = {
    email = "emmanuel_rosa@aol.com";
    github = "emmanuelrosa";
    name = "Emmanuel Rosa";
  };
  endgame = {
    email = "jack@jackkelly.name";
    github = "endgame";
    name = "Jack Kelly";
  };
  enzime = {
    email = "enzime@users.noreply.github.com";
    github = "enzime";
    name = "Michael Hoang";
  };
  eperuffo = {
    email = "info@emanueleperuffo.com";
    github = "emanueleperuffo";
    name = "Emanuele Peruffo";
  };
  epitrochoid = {
    email = "mpcervin@uncg.edu";
    name = "Mabry Cervin";
  };
  eqyiel = {
    email = "ruben@maher.fyi";
    github = "eqyiel";
    name = "Ruben Maher";
  };
  eraserhd = {
    email = "jason.m.felice@gmail.com";
    github = "eraserhd";
    name = "Jason Felice";
  };
  ericbmerritt = {
    email = "eric@afiniate.com";
    github = "ericbmerritt";
    name = "Eric Merritt";
  };
  ericsagnes = {
    email = "eric.sagnes@gmail.com";
    github = "ericsagnes";
    name = "Eric Sagnes";
  };
  ericson2314 = {
    email = "John.Ericson@Obsidian.Systems";
    github = "ericson2314";
    name = "John Ericson";
  };
  erictapen = {
    email = "justin.humm@posteo.de";
    github = "erictapen";
    name = "Justin Humm";
    keys = [{
      longkeyid = "rsa4096/0x438871E000AA178E";
      fingerprint = "984E 4BAD 9127 4D0E AE47  FF03 4388 71E0 00AA 178E";
    }];
  };
  erikryb = {
    email = "erik.rybakken@math.ntnu.no";
    github = "erikryb";
    name = "Erik Rybakken";
  };
  erosennin = {
    email = "ag@sologoc.com";
    github = "erosennin";
    name = "Andrey Golovizin";
  };
  ertes = {
    email = "esz@posteo.de";
    github = "ertes";
    name = "Ertugrul Söylemez";
  };
  Esteth = {
    email = "adam.copp@gmail.com";
    name = "Adam Copp";
  };
  ethercrow = {
    email = "ethercrow@gmail.com";
    github = "ethercrow";
    name = "Dmitry Ivanov";
  };
  etu = {
    email = "elis@hirwing.se";
    github = "etu";
    name = "Elis Hirwing";
    keys = [{
      longkeyid = "rsa4096/0xD57EFA625C9A925F";
      fingerprint = "67FE 98F2 8C44 CF22 1828  E12F D57E FA62 5C9A 925F";
    }];
  };
  evck = {
    email = "eric@evenchick.com";
    github = "ericevenchick";
    name = "Eric Evenchick";
  };
  exfalso = {
    email = "0slemi0@gmail.com";
    github = "exfalso";
    name = "Andras Slemmer";
  };
  exi = {
    email = "nixos@reckling.org";
    github = "exi";
    name = "Reno Reckling";
  };
  exlevan = {
    email = "exlevan@gmail.com";
    github = "exlevan";
    name = "Alexey Levan";
  };
  expipiplus1 = {
    email = "nix@monoid.al";
    github = "expipiplus1";
    name = "Joe Hermaszewski";
  };
  eyjhb = {
    email = "eyjhbb@gmail.com";
    github = "eyJhb";
    name = "eyJhb";
  };
  f--t = {
    email = "git@f-t.me";
    github = "f--t";
    name = "f--t";
  };
  f-breidenstein = {
    email = "mail@felixbreidenstein.de";
    github = "f-breidenstein";
    name = "Felix Breidenstein";
  };
  fadenb = {
    email = "tristan.helmich+nixos@gmail.com";
    github = "fadenb";
    name = "Tristan Helmich";
  };
  falsifian = {
    email = "james.cook@utoronto.ca";
    github = "falsifian";
    name = "James Cook";
  };
  fare = {
    email = "fahree@gmail.com";
    github = "fare";
    name = "Francois-Rene Rideau";
  };
  fdns = {
    email = "fdns02@gmail.com";
    github = "fdns";
    name = "Felipe Espinoza";
  };
  ffinkdevs = {
    email = "fink@h0st.space";
    github = "ffinkdevs";
    name = "Fabian Fink";
  };
  fgaz = {
    email = "fgaz@fgaz.me";
    github = "fgaz";
    name = "Francesco Gazzetta";
  };
  FireyFly = {
    email = "nix@firefly.nu";
    github = "FireyFly";
    name = "Jonas Höglund";
  };
  flexw = {
    email = "felix.weilbach@t-online.de";
    github = "FlexW";
    name = "Felix Weilbach";
  };
  flokli = {
    email = "flokli@flokli.de";
    github = "flokli";
    name = "Florian Klink";
  };
  FlorianFranzen = {
    email = "Florian.Franzen@gmail.com";
    github = "FlorianFranzen";
    name = "Florian Franzen";
  };
  florianjacob = {
    email = "projects+nixos@florianjacob.de";
    github = "florianjacob";
    name = "Florian Jacob";
  };
  flosse = {
    email = "mail@markus-kohlhase.de";
    github = "flosse";
    name = "Markus Kohlhase";
  };
  fluffynukeit = {
    email = "dan@fluffynukeit.com";
    github = "fluffynukeit";
    name = "Daniel Austin";
  };
  fmthoma = {
    email = "f.m.thoma@googlemail.com";
    github = "fmthoma";
    name = "Franz Thoma";
  };
  forkk = {
    email = "forkk@forkk.net";
    github = "forkk";
    name = "Andrew Okin";
  };
  fornever = {
    email = "friedrich@fornever.me";
    github = "fornever";
    name = "Friedrich von Never";
  };
  fpletz = {
    email = "fpletz@fnordicwalking.de";
    github = "fpletz";
    name = "Franz Pletz";
    keys = [{
      longkeyid = "rsa4096/0x846FDED7792617B4";
      fingerprint = "8A39 615D CE78 AF08 2E23  F303 846F DED7 7926 17B4";
    }];
  };
  fps = {
    email = "mista.tapas@gmx.net";
    github = "fps";
    name = "Florian Paul Schmidt";
  };

  fragamus = {
    email = "innovative.engineer@gmail.com";
    github = "fragamus";
    name = "Michael Gough";
  };

  fredeb = {
    email = "im@fredeb.dev";
    github = "fredeeb";
    name = "Frede Emil";
  };
  freepotion = {
    email = "free.potion@yandex.ru";
    github = "freepotion";
    name = "Free Potion";
  };
  freezeboy = {
    email = "freezeboy@users.noreply.github.com";
    github = "freezeboy";
    name = "freezeboy";
  };
  Fresheyeball = {
    email = "fresheyeball@gmail.com";
    github = "fresheyeball";
    name = "Isaac Shapira";
  };
  fridh = {
    email = "fridh@fridh.nl";
    github = "fridh";
    name = "Frederik Rietdijk";
  };
  frlan = {
    email = "frank@frank.uvena.de";
    github = "frlan";
    name = "Frank Lanitz";
  };
  fro_ozen = {
    email = "fro_ozen@gmx.de";
    github = "froozen";
    name = "fro_ozen";
  };
  frontsideair = {
    email = "photonia@gmail.com";
    github = "frontsideair";
    name = "Fatih Altinok";
  };
  ftrvxmtrx = {
    email = "ftrvxmtrx@gmail.com";
    github = "ftrvxmtrx";
    name = "Siarhei Zirukin";
  };
  fuerbringer = {
    email = "severin@fuerbringer.info";
    github = "fuerbringer";
    name = "Severin Fürbringer";
  };
  funfunctor = {
    email = "eocallaghan@alterapraxis.com";
    name = "Edward O'Callaghan";
  };
  fusion809 = {
    email = "brentonhorne77@gmail.com";
    github = "fusion809";
    name = "Brenton Horne";
  };
  fuuzetsu = {
    email = "fuuzetsu@fuuzetsu.co.uk";
    github = "fuuzetsu";
    name = "Mateusz Kowalczyk";
  };
  fuwa = {
    email = "echowss@gmail.com";
    github = "fuwa0529";
    name = "Haruka Akiyama";
  };
  fuzzy-id = {
    email = "hacking+nixos@babibo.de";
    name = "Thomas Bach";
  };
  fxfactorial = {
    email = "edgar.factorial@gmail.com";
    github = "fxfactorial";
    name = "Edgar Aroutiounian";
  };
  gabesoft = {
    email = "gabesoft@gmail.com";
    github = "gabesoft";
    name = "Gabriel Adomnicai";
  };
  gal_bolle = {
    email = "florent.becker@ens-lyon.org";
    github = "FlorentBecker";
    name = "Florent Becker";
  };
  garbas = {
    email = "rok@garbas.si";
    github = "garbas";
    name = "Rok Garbas";
  };
  garrison = {
    email = "jim@garrison.cc";
    github = "garrison";
    name = "Jim Garrison";
  };
  gavin = {
    email = "gavin.rogers@holo.host";
    github = "gavinrogers";
    name = "Gavin Rogers";
  };
  gebner = {
    email = "gebner@gebner.org";
    github = "gebner";
    name = "Gabriel Ebner";
  };
  geistesk = {
    email = "post@0x21.biz";
    github = "geistesk";
    name = "Alvar Penning";
  };
  genesis = {
    email = "ronan@aimao.org";
    github = "bignaux";
    name = "Ronan Bignaux";
  };
  georgewhewell = {
    email = "georgerw@gmail.com";
    github = "georgewhewell";
    name = "George Whewell";
  };
  gerschtli = {
    email = "tobias.happ@gmx.de";
    github = "Gerschtli";
    name = "Tobias Happ";
  };
  ggpeti = {
    email = "ggpeti@gmail.com";
    github = "ggpeti";
    name = "Peter Ferenczy";
  };
  gilligan = {
    email = "tobias.pflug@gmail.com";
    github = "gilligan";
    name = "Tobias Pflug";
  };
  giogadi = {
    email = "lgtorres42@gmail.com";
    github = "giogadi";
    name = "Luis G. Torres";
  };
  gleber = {
    email = "gleber.p@gmail.com";
    github = "gleber";
    name = "Gleb Peregud";
  };
  glenns = {
    email = "glenn.searby@gmail.com";
    github = "glenns";
    name = "Glenn Searby";
  };
  globin = {
    email = "mail@glob.in";
    github = "globin";
    name = "Robin Gloster";
  };
  gnidorah = {
    email = "gnidorah@yandex.com";
    github = "gnidorah";
    name = "Alex Ivanov";
  };
  goibhniu = {
    email = "cillian.deroiste@gmail.com";
    github = "cillianderoiste";
    name = "Cillian de Róiste";
  };
  Gonzih = {
    email = "gonzih@gmail.com";
    github = "Gonzih";
    name = "Max Gonzih";
  };
  goodrone = {
    email = "goodrone@gmail.com";
    github = "goodrone";
    name = "Andrew Trachenko";
  };
  gpyh = {
    email = "yacine.hmito@gmail.com";
    github = "yacinehmito";
    name = "Yacine Hmito";
  };
  grahamc = {
    email = "graham@grahamc.com";
    github = "grahamc";
    name = "Graham Christensen";
  };
  grburst = {
    email = "grburst@openmailbox.org";
    github = "grburst";
    name = "Julius Elias";
  };
  greydot = {
    email = "lanablack@amok.cc";
    github = "greydot";
    name = "Lana Black";
  };
  gridaphobe = {
    email = "eric@seidel.io";
    github = "gridaphobe";
    name = "Eric Seidel";
  };
  guibert = {
    email = "david.guibert@gmail.com";
    github = "dguibert";
    name = "David Guibert";
  };
  groodt = {
    email = "groodt@gmail.com";
    github = "groodt";
    name = "Greg Roodt";
  };
  guibou = {
    email = "guillaum.bouchard@gmail.com";
    github = "guibou";
    name = "Guillaume Bouchard";
  };
  guillaumekoenig = {
    email = "guillaume.edward.koenig@gmail.com";
    github = "guillaumekoenig";
    name = "Guillaume Koenig";
  };
  guyonvarch = {
    email = "joris@guyonvarch.me";
    github = "guyonvarch";
    name = "Joris Guyonvarch";
  };
  hakuch = {
    email = "hakuch@gmail.com";
    github = "hakuch";
    name = "Jesse Haber-Kucharsky";
  };
  hamhut1066 = {
    email = "github@hamhut1066.com";
    github = "hamhut1066";
    name = "Hamish Hutchings";
  };
  hansjoergschurr = {
    email = "commits@schurr.at";
    github = "hansjoergschurr";
    name = "Hans-Jörg Schurr";
    };
  HaoZeke = {
    email = "r95g10@gmail.com";
    github = "haozeke";
    name = "Rohit Goswami";
  };
  haslersn = {
    email = "haslersn@fius.informatik.uni-stuttgart.de";
    github = "haslersn";
    name = "Sebastian Hasler";
  };
  havvy = {
    email = "ryan.havvy@gmail.com";
    github = "havvy";
    name = "Ryan Scheel";
  };
  hax404 = {
    email = "hax404foogit@hax404.de";
    github = "hax404";
    name = "Georg Haas";
  };
  hbunke = {
    email = "bunke.hendrik@gmail.com";
    github = "hbunke";
    name = "Hendrik Bunke";
  };
  hce = {
    email = "hc@hcesperer.org";
    github = "hce";
    name = "Hans-Christian Esperer";
  };
  hectorj = {
    email = "hector.jusforgues+nixos@gmail.com";
    github = "hectorj";
    name = "Hector Jusforgues";
  };
  hedning = {
    email = "torhedinbronner@gmail.com";
    github = "hedning";
    name = "Tor Hedin Brønner";
  };
  heel = {
    email = "parizhskiy@gmail.com";
    github = "heel";
    name = "Sergii Paryzhskyi";
  };
  helkafen = {
    email = "arnaudpourseb@gmail.com";
    github = "Helkafen";
    name = "Sébastian Méric de Bellefon";
  };
  henrytill = {
    email = "henrytill@gmail.com";
    github = "henrytill";
    name = "Henry Till";
  };
  hhm = {
    email = "heehooman+nixpkgs@gmail.com";
    github = "hhm0";
    name = "hhm";
  };
  hinton = {
    email = "t@larkery.com";
    name = "Tom Hinton";
  };
  hlolli = {
    email = "hlolli@gmail.com";
    github = "hlolli";
    name = "Hlodver Sigurdsson";
  };
  hodapp = {
    email = "hodapp87@gmail.com";
    github = "Hodapp87";
    name = "Chris Hodapp";
  };
  hrdinka = {
    email = "c.nix@hrdinka.at";
    github = "hrdinka";
    name = "Christoph Hrdinka";
  };
  hschaeidt = {
    email = "he.schaeidt@gmail.com";
    github = "hschaeidt";
    name = "Hendrik Schaeidt";
  };
  htr = {
    email = "hugo@linux.com";
    github = "htr";
    name = "Hugo Tavares Reis";
  };
  hyphon81 = {
    email = "zero812n@gmail.com";
    github = "hyphon81";
    name = "Masato Yonekawa";
  };
  iand675 = {
    email = "ian@iankduncan.com";
    github = "iand675";
    name = "Ian Duncan";
  };
  ianwookim = {
    email = "ianwookim@gmail.com";
    github = "wavewave";
    name = "Ian-Woo Kim";
  };
  iblech = {
    email = "iblech@speicherleck.de";
    github = "iblech";
    name = "Ingo Blechschmidt";
  };
  idontgetoutmuch = {
    email = "dominic@steinitz.org";
    github = "idontgetoutmuch";
    name = "Dominic Steinitz";
  };
  igsha = {
    email = "igor.sharonov@gmail.com";
    github = "igsha";
    name = "Igor Sharonov";
  };
  iimog = {
    email = "iimog@iimog.org";
    github = "iimog";
    name = "Markus J. Ankenbrand";
  };
  ikervagyok = {
    email = "ikervagyok@gmail.com";
    github = "ikervagyok";
    name = "Balázs Lengyel";
  };
  ilikeavocadoes = {
    email = "ilikeavocadoes@hush.com";
    github = "ilikeavocadoes";
    name = "Lassi Haasio";
  };
  illegalprime = {
    email = "themichaeleden@gmail.com";
    github = "illegalprime";
    name = "Michael Eden";
  };
  ilya-kolpakov = {
    email = "ilya.kolpakov@gmail.com";
    github = "ilya-kolpakov";
    name = "Ilya Kolpakov";
  };
  imalison = {
    email = "IvanMalison@gmail.com";
    github = "IvanMalison";
    name = "Ivan Malison";
  };
  imalsogreg = {
    email = "imalsogreg@gmail.com";
    github = "imalsogreg";
    name = "Greg Hale";
  };
  imuli = {
    email = "i@imu.li";
    github = "imuli";
    name = "Imuli";
  };
  infinisil = {
    email = "infinisil@icloud.com";
    github = "infinisil";
    name = "Silvan Mosberger";
  };
  ingenieroariel = {
    email = "ariel@nunez.co";
    github = "ingenieroariel";
    name = "Ariel Nunez";
  };
  ironpinguin = {
    email = "michele@catalano.de";
    github = "ironpinguin";
    name = "Michele Catalano";
  };
  ivan = {
    email = "ivan@ludios.org";
    github = "ivan";
    name = "Ivan Kozik";
  };
  ivan-tkatchev = {
    email = "tkatchev@gmail.com";
    name = "Ivan Tkatchev";
  };
  ivegotasthma = {
    email = "ivegotasthma@protonmail.com";
    github = "ivegotasthma";
    name = "John Doe";
    keys = [{
      longkeyid = "rsa4096/09AC52AEA87817A4";
      fingerprint = "4008 2A5B 56A4 79B9 83CB  95FD 09AC 52AE A878 17A4";
    }];
  };
  ixmatus = {
    email = "parnell@digitalmentat.com";
    github = "ixmatus";
    name = "Parnell Springmeyer";
  };
  ixxie = {
    email = "matan@fluxcraft.net";
    github = "ixxie";
    name = "Matan Bendix Shenhav";
  };
  izorkin = {
    email = "Izorkin@gmail.com";
    github = "izorkin";
    name = "Yurii Izorkin";
  };
  j-keck = {
    email = "jhyphenkeck@gmail.com";
    github = "j-keck";
    name = "Jürgen Keck";
  };
  jagajaga = {
    email = "ars.seroka@gmail.com";
    github = "jagajaga";
    name = "Arseniy Seroka";
  };
  jakelogemann = {
    email = "jake.logemann@gmail.com";
    github = "jakelogemann";
    name = "Jake Logemann";
  };
  jakewaksbaum = {
    email = "jake.waksbaum@gmail.com";
    github = "jbaum98";
    name = "Jake Waksbaum";
  };
  jammerful = {
    email = "jammerful@gmail.com";
    github = "jammerful";
    name = "jammerful";
  };
  jansol = {
    email = "jan.solanti@paivola.fi";
    github = "jansol";
    name = "Jan Solanti";
  };
  javaguirre = {
    email = "contacto@javaguirre.net";
    github = "javaguirre";
    name = "Javier Aguirre";
  };
  jb55 = {
    email = "jb55@jb55.com";
    github = "jb55";
    name = "William Casarin";
  };
  jbedo = {
    email = "cu@cua0.org";
    github = "jbedo";
    name = "Justin Bedő";
  };
  jbgi = {
    email = "jb@giraudeau.info";
    github = "jbgi";
    name = "Jean-Baptiste Giraudeau";
  };
  jchw = {
    email = "johnwchadwick@gmail.com";
    github = "jchv";
    name = "John Chadwick";
  };
  jcumming = {
    email = "jack@mudshark.org";
    name = "Jack Cummings";
  };
  jD91mZM2 = {
    email = "me@krake.one";
    github = "jD91mZM2";
    name = "jD91mZM2";
  };
  jdagilliland = {
    email = "jdagilliland@gmail.com";
    github = "jdagilliland";
    name = "Jason Gilliland";
  };
  jdehaas = {
    email = "qqlq@nullptr.club";
    github = "jeroendehaas";
    name = "Jeroen de Haas";
  };
  jefdaj = {
    email = "jefdaj@gmail.com";
    github = "jefdaj";
    name = "Jeffrey David Johnson";
  };
  jensbin = {
    email = "jensbin+git@pm.me";
    github = "jensbin";
    name = "Jens Binkert";
  };
  jerith666 = {
    email = "github@matt.mchenryfamily.org";
    github = "jerith666";
    name = "Matt McHenry";
  };
  jeschli = {
    email = "jeschli@gmail.com";
    github = "jeschli";
    name = "Markus Hihn";
  };
  jethro = {
    email = "jethrokuan95@gmail.com";
    github = "jethrokuan";
    name = "Jethro Kuan";
  };
  jfb = {
    email = "james@yamtime.com";
    github = "tftio";
    name = "James Felix Black";
  };
  jflanglois = {
    email = "yourstruly@julienlanglois.me";
    github = "jflanglois";
    name = "Julien Langlois";
  };
  jfrankenau = {
    email = "johannes@frankenau.net";
    github = "jfrankenau";
    name = "Johannes Frankenau";
  };
  jgeerds = {
    email = "jascha@geerds.org";
    github = "jgeerds";
    name = "Jascha Geerds";
  };
  jgertm = {
    email = "jger.tm@gmail.com";
    github = "jgertm";
    name = "Tim Jaeger";
  };
  jgillich = {
    email = "jakob@gillich.me";
    github = "jgillich";
    name = "Jakob Gillich";
  };
  jglukasik = {
    email = "joseph@jgl.me";
    github = "jglukasik";
    name = "Joseph Lukasik";
  };
  jhhuh = {
    email = "jhhuh.note@gmail.com";
    github = "jhhuh";
    name = "Ji-Haeng Huh";
  };
  jhillyerd = {
    email = "james+nixos@hillyerd.com";
    github = "jhillyerd";
    name = "James Hillyerd";
  };
  jirkamarsik = {
    email = "jiri.marsik89@gmail.com";
    github = "jirkamarsik";
    name = "Jirka Marsik";
  };
  jlesquembre = {
    email = "jl@lafuente.me";
    github = "jlesquembre";
    name = "José Luis Lafuente";
  };
  jluttine = {
    email = "jaakko.luttinen@iki.fi";
    github = "jluttine";
    name = "Jaakko Luttinen";
  };
  jmagnusj = {
    email = "jmagnusj@gmail.com";
    github = "magnusjonsson";
    name = "Johan Magnus Jonsson";
  };
  jmettes = {
    email = "jonathan@jmettes.com";
    github = "jmettes";
    name = "Jonathan Mettes";
  };
  joachifm = {
    email = "joachifm@fastmail.fm";
    github = "joachifm";
    name = "Joachim Fasting";
  };
  joamaki = {
    email = "joamaki@gmail.com";
    github = "joamaki";
    name = "Jussi Maki";
  };
  joelburget = {
    email = "joelburget@gmail.com";
    github = "joelburget";
    name = "Joel Burget";
  };
  joelmo = {
    email = "joel.moberg@gmail.com";
    github = "joelmo";
    name = "Joel Moberg";
  };
  joelteon = {
    email = "me@joelt.io";
    name = "Joel Taylor";
  };
  johanot = {
    email = "write@ownrisk.dk";
    github = "johanot";
    name = "Johan Thomsen";
  };
  johbo = {
    email = "johannes@bornhold.name";
    github = "johbo";
    name = "Johannes Bornhold";
  };
  johnazoidberg = {
    email = "git@danielschaefer.me";
    github = "johnazoidberg";
    name = "Daniel Schäfer";
  };
  johnchildren = {
    email = "john.a.children@gmail.com";
    github = "johnchildren";
    name = "John Children";
  };
  johnmh = {
    email = "johnmh@openblox.org";
    github = "johnmh";
    name = "John M. Harris, Jr.";
  };
  johnramsden = {
    email = "johnramsden@riseup.net";
    github = "johnramsden";
    name = "John Ramsden";
  };
  joko = {
    email = "ioannis.koutras@gmail.com";
    github = "jokogr";
    keys = [{
      # compare with https://keybase.io/joko
      longkeyid = "rsa2048/0x85EAE7D9DF56C5CA";
      fingerprint = "B154 A8F9 0610 DB45 0CA8  CF39 85EA E7D9 DF56 C5CA";
    }];
    name = "Ioannis Koutras";
  };
  jonafato = {
    email = "jon@jonafato.com";
    github = "jonafato";
    name = "Jon Banafato";
  };
  jonathanreeve = {
    email = "jon.reeve@gmail.com";
    github = "JonathanReeve";
    name = "Jonathan Reeve";
  };
  joncojonathan = {
    email = "joncojonathan@gmail.com";
    github = "joncojonathan";
    name = "Jonathan Haddock";
  };
  jonringer = {
    email = "jonringer117@gmail.com";
    github = "jonringer";
    name = "Jonathan Ringer";
  };
  jorsn = {
    name = "Johannes Rosenberger";
    email = "johannes@jorsn.eu";
    github = "jorsn";
  };
  jpdoyle = {
    email = "joethedoyle@gmail.com";
    github = "jpdoyle";
    name = "Joe Doyle";
  };
  jpierre03 = {
    email = "nix@prunetwork.fr";
    github = "jpierre03";
    name = "Jean-Pierre PRUNARET";
  };
  jpotier = {
    email = "jpo.contributes.to.nixos@marvid.fr";
    github = "jpotier";
    name = "Martin Potier";
  };
  jqueiroz = {
    email = "nixos@johnjq.com";
    github = "jqueiroz";
    name = "Jonathan Queiroz";
  };
  jraygauthier = {
    email = "jraygauthier@gmail.com";
    github = "jraygauthier";
    name = "Raymond Gauthier";
  };
  jtojnar = {
    email = "jtojnar@gmail.com";
    github = "jtojnar";
    name = "Jan Tojnar";
  };
  juaningan = {
    email = "juaningan@gmail.com";
    github = "juaningan";
    name = "Juan Rodal";
  };
  juliendehos = {
    email = "dehos@lisic.univ-littoral.fr";
    github = "juliendehos";
    name = "Julien Dehos";
  };
  justinwoo = {
    email = "moomoowoo@gmail.com";
    github = "justinwoo";
    name = "Justin Woo";
  };
  jwiegley = {
    email = "johnw@newartisans.com";
    github = "jwiegley";
    name = "John Wiegley";
  };
  jwilberding = {
    email = "jwilberding@afiniate.com";
    name = "Jordan Wilberding";
  };
  jyp = {
    email = "jeanphilippe.bernardy@gmail.com";
    github = "jyp";
    name = "Jean-Philippe Bernardy";
  };
  jzellner = {
    email = "jeffz@eml.cc";
    github = "sofuture";
    name = "Jeff Zellner";
  };
  kaiha = {
    email = "kai.harries@gmail.com";
    github = "kaiha";
    name = "Kai Harries";
  };
  kalbasit = {
    email = "wael.nasreddine@gmail.com";
    github = "kalbasit";
    name = "Wael Nasreddine";
  };
  kamilchm = {
    email = "kamil.chm@gmail.com";
    github = "kamilchm";
    name = "Kamil Chmielewski";
  };
  kampfschlaefer = {
    email = "arnold@arnoldarts.de";
    github = "kampfschlaefer";
    name = "Arnold Krille";
  };
  karolchmist = {
    email = "info+nix@chmist.com";
    name = "karolchmist";
  };
  kazcw = {
    email = "kaz@lambdaverse.org";
    github = "kazcw";
    name = "Kaz Wesley";
  };
  kentjames = {
    email = "jameschristopherkent@gmail.com";
    github = "kentjames";
    name = "James Kent";
  };
  kevincox = {
    email = "kevincox@kevincox.ca";
    github = "kevincox";
    name = "Kevin Cox";
  };
  khumba = {
    email = "bog@khumba.net";
    github = "khumba";
    name = "Bryan Gardiner";
  };
  KibaFox = {
    email = "kiba.fox@foxypossibilities.com";
    github = "KibaFox";
    name = "Kiba Fox";
  };
  kierdavis = {
    email = "kierdavis@gmail.com";
    github = "kierdavis";
    name = "Kier Davis";
  };
  kiloreux = {
    email = "kiloreux@gmail.com";
    github = "kiloreux";
    name = "Kiloreux Emperex";
  };
  kimburgess = {
    email = "kim@acaprojects.com";
    github = "kimburgess";
    name = "Kim Burgess";
  };
  kini = {
    email = "keshav.kini@gmail.com";
    github = "kini";
    name = "Keshav Kini";
  };
  kirelagin = {
    email = "kirelagin@gmail.com";
    github = "kirelagin";
    name = "Kirill Elagin";
  };
  kisonecat = {
    email = "kisonecat@gmail.com";
    github = "kisonecat";
    name = "Jim Fowler";
  };
  kiwi = {
    email = "envy1988@gmail.com";
    github = "Kiwi";
    name = "Robert Djubek";
    keys = [{
      longkeyid = "rsa4096/0x156C88A5B0A04B2A";
      fingerprint = "8992 44FC D291 5CA2 0A97  802C 156C 88A5 B0A0 4B2A";
    }];
  };
  kjuvi = {
    email = "quentin.vaucher@pm.me";
    github = "kjuvi";
    name = "Quentin Vaucher";
  };
  kkallio = {
    email = "tierpluspluslists@gmail.com";
    name = "Karn Kallio";
  };
  klntsky = {
    email = "klntsky@gmail.com";
    name = "Vladimir Kalnitsky";
    github = "klntsky";
  };
  kmeakin = {
    email = "karlwfmeakin@gmail.com";
    name = "Karl Meakin";
    github = "Kmeakin";
  };

  kmein = {
    email = "kieran.meinhardt@gmail.com";
    name = "Kierán Meinhardt";
    github = "kmein";
  };

  knedlsepp = {
    email = "josef.kemetmueller@gmail.com";
    github = "knedlsepp";
    name = "Josef Kemetmüller";
  };
  knl = {
    email = "nikola@knezevic.co";
    github = "knl";
    name = "Nikola Knežević";
  };
  kolaente = {
    email = "k@knt.li";
    github = "kolaente";
    name = "Konrad Langenberg";
  };
  konimex = {
    email = "herdiansyah@netc.eu";
    github = "konimex";
    name = "Muhammad Herdiansyah";
  };
  koral = {
    email = "koral@mailoo.org";
    github = "k0ral";
    name = "Koral";
  };
  kovirobi = {
    email = "kovirobi@gmail.com";
    github = "kovirobi";
    name = "Kovacsics Robert";
  };
  kquick = {
    email = "quick@sparq.org";
    github = "kquick";
    name = "Kevin Quick";
  };
  kragniz = {
    email = "louis@kragniz.eu";
    github = "kragniz";
    name = "Louis Taylor";
  };
  krav = {
    email = "kristoffer@microdisko.no";
    github = "krav";
    name = "Kristoffer Thømt Ravneberg";
  };
  kroell = {
    email = "nixosmainter@makroell.de";
    github = "rokk4";
    name = "Matthias Axel Kröll";
  };
  kristoff3r = {
    email = "k.soeholm@gmail.com";
    github = "kristoff3r";
    name = "Kristoffer Søholm";
  };
  ktf = {
    email = "giulio.eulisse@cern.ch";
    github = "ktf";
    name = "Giuluo Eulisse";
  };
  ktosiek = {
    email = "tomasz.kontusz@gmail.com";
    github = "ktosiek";
    name = "Tomasz Kontusz";
  };
  kuznero = {
    email = "roman@kuznero.com";
    github = "kuznero";
    name = "Roman Kuznetsov";
  };
  kylewlacy = {
    email = "kylelacy+nix@pm.me";
    github = "kylewlacy";
    name = "Kyle Lacy";
  };
  lasandell = {
    email = "lasandell@gmail.com";
    github = "lasandell";
    name = "Luke Sandell";
  };
  lassulus = {
    email = "lassulus@gmail.com";
    github = "Lassulus";
    name = "Lassulus";
  };
  layus = {
    email = "layus.on@gmail.com";
    github = "layus";
    name = "Guillaume Maudoux";
  };
  lblasc = {
    email = "lblasc@znode.net";
    github = "lblasc";
    name = "Luka Blaskovic";
  };
  ldesgoui = {
    email = "ldesgoui@gmail.com";
    github = "ldesgoui";
    name = "Lucas Desgouilles";
  };
  league = {
    email = "league@contrapunctus.net";
    github = "league";
    name = "Christopher League";
  };
  leahneukirchen = {
    email = "leah@vuxu.org";
    github = "leahneukirchen";
    name = "Leah Neukirchen";
  };
  lebastr = {
    email = "lebastr@gmail.com";
    github = "lebastr";
    name = "Alexander Lebedev";
  };
  ledif = {
    email = "refuse@gmail.com";
    github = "ledif";
    name = "Adam Fidel";
  };
  leemachin = {
    email = "me@mrl.ee";
    github = "leemachin";
    name = "Lee Machin";
  };
  leenaars = {
    email = "ml.software@leenaa.rs";
    github = "leenaars";
    name = "Michiel Leenaars";
  };
  lejonet = {
    email = "daniel@kuehn.se";
    github = "lejonet";
    name = "Daniel Kuehn";
  };
  leo60228 = {
    email = "iakornfeld@gmail.com";
    github = "leo60228";
    name = "leo60228";
  };
  leonardoce = {
    email = "leonardo.cecchi@gmail.com";
    github = "leonardoce";
    name = "Leonardo Cecchi";
  };
  lethalman = {
    email = "lucabru@src.gnome.org";
    github = "lethalman";
    name = "Luca Bruno";
  };
  lewo = {
    email = "lewo@abesis.fr";
    github = "nlewo";
    name = "Antoine Eiche";
  };
  lheckemann = {
    email = "git@sphalerite.org";
    github = "lheckemann";
    name = "Linus Heckemann";
  };
  lhvwb = {
    email = "nathaniel.baxter@gmail.com";
    github = "nathanielbaxter";
    name = "Nathaniel Baxter";
  };
  lightdiscord = {
    email = "root@arnaud.sh";
    github = "lightdiscord";
    name = "Arnaud Pascal";
  };
  lihop = {
    email = "nixos@leroy.geek.nz";
    github = "lihop";
    name = "Leroy Hopson";
  };
  lilyball = {
    email = "lily@sb.org";
    github = "lilyball";
    name = "Lily Ballard";
  };
  limeytexan = {
    email = "limeytexan@gmail.com";
    github = "limeytexan";
    name = "Michael Brantley";
  };
  linarcx = {
    email = "linarcx@gmail.com";
    github = "linarcx";
    name = "Kaveh Ahangar";
  };
  linc01n = {
    email = "git@lincoln.hk";
    github = "linc01n";
    name = "Lincoln Lee";
  };
  linquize = {
    email = "linquize@yahoo.com.hk";
    github = "linquize";
    name = "Linquize";
  };
  linus = {
    email = "linusarver@gmail.com";
    github = "listx";
    name = "Linus Arver";
  };
  luis = {
      email = "luis.nixos@gmail.com";
      github = "Luis-Hebendanz";
      name = "Luis Hebendanz";
  };
  lionello = {
    email = "lio@lunesu.com";
    github = "lionello";
    name = "Lionello Lunesu";
  };
  lluchs = {
    email = "lukas.werling@gmail.com";
    github = "lluchs";
    name = "Lukas Werling";
  };
  lnl7 = {
    email = "daiderd@gmail.com";
    github = "lnl7";
    name = "Daiderd Jordan";
  };
  lo1tuma = {
    email = "schreck.mathias@gmail.com";
    github = "lo1tuma";
    name = "Mathias Schreck";
  };
  loewenheim = {
    email = "loewenheim@mailbox.org";
    github = "loewenheim";
    name = "Sebastian Zivota";
  };
  lopsided98 = {
    email = "benwolsieffer@gmail.com";
    github = "lopsided98";
    name = "Ben Wolsieffer";
  };
  loskutov = {
    email = "ignat.loskutov@gmail.com";
    github = "loskutov";
    name = "Ignat Loskutov";
  };
  lovek323 = {
    email = "jason@oconal.id.au";
    github = "lovek323";
    name = "Jason O'Conal";
  };
  lowfatcomputing = {
    email = "andreas.wagner@lowfatcomputing.org";
    github = "lowfatcomputing";
    name = "Andreas Wagner";
  };
  lschuermann = {
    email = "leon.git@is.currently.online";
    github = "lschuermann";
    name = "Leon Schuermann";
  };
  lsix = {
    email = "lsix@lancelotsix.com";
    github = "lsix";
    name = "Lancelot SIX";
  };
  ltavard = {
    email = "laure.tavard@univ-grenoble-alpes.fr";
    github = "ltavard";
    name = "Laure Tavard";
  };
  lucas8 = {
    email = "luc.linux@mailoo.org";
    github = "lucas8";
    name = "Luc Chabassier";
  };
  lucus16 = {
    email = "lars.jellema@gmail.com";
    github = "Lucus16";
    name = "Lars Jellema";
  };
  ludo = {
    email = "ludo@gnu.org";
    github = "civodul";
    name = "Ludovic Courtès";
  };
  lufia = {
    email = "lufia@lufia.org";
    github = "lufia";
    name = "Kyohei Kadota";
  };
  luispedro = {
    email = "luis@luispedro.org";
    github = "luispedro";
    name = "Luis Pedro Coelho";
  };
  lukeadams = {
    email = "luke.adams@belljar.io";
    github = "lukeadams";
    name = "Luke Adams";
  };
  lukebfox = {
    email = "lbentley-fox1@sheffield.ac.uk";
    github = "lukebfox";
    name = "Luke Bentley-Fox";
  };
  lukego = {
    email = "luke@snabb.co";
    github = "lukego";
    name = "Luke Gorrie";
  };
  luz = {
    email = "luz666@daum.net";
    github = "Luz";
    name = "Luz";
  };
  lw = {
    email = "lw@fmap.me";
    github = "lolwat97";
    name = "Sergey Sofeychuk";
  };
  lyt = {
    email = "wheatdoge@gmail.com";
    name = "Tim Liou";
  };
  m3tti = {
    email = "mathaeus.peter.sander@gmail.com";
    name = "Mathaeus Sander";
  };
  ma27 = {
    email = "maximilian@mbosch.me";
    github = "ma27";
    name = "Maximilian Bosch";
  };
  ma9e = {
    email = "sean@lfo.team";
    github = "ma9e";
    name = "Sean Haugh";
  };
  madjar = {
    email = "georges.dubus@compiletoi.net";
    github = "madjar";
    name = "Georges Dubus";
  };
  mafo = {
    email = "Marc.Fontaine@gmx.de";
    github = "MarcFontaine";
    name = "Marc Fontaine";
  };
  magnetophon = {
    email = "bart@magnetophon.nl";
    github = "magnetophon";
    name = "Bart Brouns";
  };
  mahe = {
    email = "matthias.mh.herrmann@gmail.com";
    github = "2chilled";
    name = "Matthias Herrmann";
  };
  makefu = {
    email = "makefu@syntax-fehler.de";
    github = "makefu";
    name = "Felix Richter";
  };
  malyn = {
    email = "malyn@strangeGizmo.com";
    github = "malyn";
    name = "Michael Alyn Miller";
  };
  manveru = {
    email = "m.fellinger@gmail.com";
    github = "manveru";
    name = "Michael Fellinger";
  };
  marcweber = {
    email = "marco-oweber@gmx.de";
    github = "marcweber";
    name = "Marc Weber";
  };
	marenz = {
		email = "marenz@arkom.men";
		github = "marenz2569";
		name = "Markus Schmidl";
	};
  markus1189 = {
    email = "markus1189@gmail.com";
    github = "markus1189";
    name = "Markus Hauck";
  };
  markuskowa = {
    email = "markus.kowalewski@gmail.com";
    github = "markuskowa";
    name = "Markus Kowalewski";
  };
  markWot = {
    email = "markus@wotringer.de";
    name = "Markus Wotringer";
  };
  marius851000 = {
    email = "mariusdavid@laposte.net";
    name = "Marius David";
    github = "marius851000";
  };
  marsam = {
    email = "marsam@users.noreply.github.com";
    github = "marsam";
    name = "Mario Rodas";
  };
  martijnvermaat = {
    email = "martijn@vermaat.name";
    github = "martijnvermaat";
    name = "Martijn Vermaat";
  };
  martingms = {
    email = "martin@mg.am";
    github = "martingms";
    name = "Martin Gammelsæter";
  };
  marzipankaiser = {
    email = "nixos@gaisseml.de";
    github = "marzipankaiser";
    name = "Marcial Gaißert";
    keys = [{
      longkeyid = "rsa2048/0xB629036BE399EEE9";
      fingerprint = "B573 5118 0375 A872 FBBF  7770 B629 036B E399 EEE9";
    }];
  };
  matejc = {
    email = "cotman.matej@gmail.com";
    github = "matejc";
    name = "Matej Cotman";
  };
  mathnerd314 = {
    email = "mathnerd314.gph+hs@gmail.com";
    github = "mathnerd314";
    name = "Mathnerd314";
  };
  matklad = {
    email = "aleksey.kladov@gmail.com";
    github = "matklad";
    name = "matklad";
  };
  matthewbauer = {
    email = "mjbauer95@gmail.com";
    github = "matthewbauer";
    name = "Matthew Bauer";
  };
  matthiasbeyer = {
    email = "mail@beyermatthias.de";
    github = "matthiasbeyer";
    name = "Matthias Beyer";
  };
  matti-kariluoma = {
    email = "matti@kariluo.ma";
    github = "matti-kariluoma";
    name = "Matti Kariluoma";
  };
  maurer = {
    email = "matthew.r.maurer+nix@gmail.com";
    github = "maurer";
    name = "Matthew Maurer";
  };
  mbakke = {
    email = "mbakke@fastmail.com";
    github = "mbakke";
    name = "Marius Bakke";
  };
  mbbx6spp = {
    email = "me@susanpotter.net";
    github = "mbbx6spp";
    name = "Susan Potter";
  };
  mbe = {
    email = "brandonedens@gmail.com";
    github = "brandonedens";
    name = "Brandon Edens";
  };
  mbode = {
    email = "maxbode@gmail.com";
    github = "mbode";
    name = "Maximilian Bode";
  };
  mboes = {
    email = "mboes@tweag.net";
    github = "mboes";
    name = "Mathieu Boespflug";
  };
  mbrgm = {
    email = "marius@yeai.de";
    github = "mbrgm";
    name = "Marius Bergmann";
  };
  mcmtroffaes = {
    email = "matthias.troffaes@gmail.com";
    github = "mcmtroffaes";
    name = "Matthias C. M. Troffaes";
  };
  mdaiter = {
    email = "mdaiter8121@gmail.com";
    github = "mdaiter";
    name = "Matthew S. Daiter";
  };
  mdevlamynck = {
    email = "matthias.devlamynck@mailoo.org";
    github = "mdevlamynck";
    name = "Matthias Devlamynck";
  };
  meditans = {
    email = "meditans@gmail.com";
    github = "meditans";
    name = "Carlo Nucera";
  };
  megheaiulian = {
    email = "iulian.meghea@gmail.com";
    github = "megheaiulian";
    name = "Meghea Iulian";
  };
  mehandes = {
    email = "niewskici@gmail.com";
    github = "mehandes";
    name = "Matt Deming";
  };
  meisternu = {
    email = "meister@krutt.org";
    github = "meisternu";
    name = "Matt Miemiec";
  };
  melchips = {
    email = "truphemus.francois@gmail.com";
    github = "melchips";
    name = "Francois Truphemus";
  };
  melsigl = {
    email = "melanie.bianca.sigl@gmail.com";
    github = "melsigl";
    name = "Melanie B. Sigl";
  };
  melkor333 = {
    email = "samuel@ton-kunst.ch";
    github = "melkor333";
    name = "Samuel Ruprecht";
  };
  metabar = {
    email = "softs@metabarcoding.org";
    name = "Celine Mercier";
  };
  mfossen = {
    email = "msfossen@gmail.com";
    github = "mfossen";
    name = "Mitchell Fossen";
  };
  mgdelacroix = {
    email = "mgdelacroix@gmail.com";
    github = "mgdelacroix";
    name = "Miguel de la Cruz";
  };
  mgregoire = {
    email = "gregoire@martinache.net";
    github = "M-Gregoire";
    name = "Gregoire Martinache";
  };
  mgttlinger = {
    email = "megoettlinger@gmail.com";
    github = "mgttlinger";
    name = "Merlin Göttlinger";
  };
  mguentner = {
    email = "code@klandest.in";
    github = "mguentner";
    name = "Maximilian Güntner";
  };
   mhaselsteiner = {
    email = "magdalena.haselsteiner@gmx.at";
    github = "mhaselsteiner";
    name = "Magdalena Haselsteiner";
  };
  mic92 = {
    email = "joerg@thalheim.io";
    github = "mic92";
    name = "Jörg Thalheim";
    keys = [{
      # compare with https://keybase.io/Mic92
      longkeyid = "rsa4096/0x003F2096411B5F92";
      fingerprint = "3DEE 1C55 6E1C 3DC5 54F5  875A 003F 2096 411B 5F92";
    }];
  };
  michaelpj = {
    email = "michaelpj@gmail.com";
    github = "michaelpj";
    name = "Michael Peyton Jones";
  };
  michalrus = {
    email = "m@michalrus.com";
    github = "michalrus";
    name = "Michal Rus";
  };
  michelk = {
    email = "michel@kuhlmanns.info";
    github = "michelk";
    name = "Michel Kuhlmann";
  };
  mickours = {
    email = "mickours@gmail.com<";
    github = "mickours";
    name = "Michael Mercier";
  };
  midchildan = {
    email = "midchildan+nix@gmail.com";
    github = "midchildan";
    name = "midchildan";
  };
  mikefaille = {
    email = "michael@faille.io";
    github = "mikefaille";
    name = "Michaël Faille";
  };
  mikoim = {
    email = "ek@esh.ink";
    github = "mikoim";
    name = "Eshin Kunishima";
  };
  miltador = {
    email = "miltador@yandex.ua";
    name = "Vasiliy Solovey";
  };
  mimadrid = {
    email = "mimadrid@ucm.es";
    github = "mimadrid";
    name = "Miguel Madrid";
  };
  minijackson = {
    email = "minijackson@riseup.net";
    github = "minijackson";
    name = "Rémi Nicole";
  };
  mirdhyn = {
    email = "mirdhyn@gmail.com";
    github = "mirdhyn";
    name = "Merlin Gaillard";
  };
  mirrexagon = {
    email = "mirrexagon@mirrexagon.com";
    github = "mirrexagon";
    name = "Andrew Abbott";
  };
  mjanczyk = {
    email = "m@dragonvr.pl";
    github = "mjanczyk";
    name = "Marcin Janczyk";
  };
  mjp = {
    email = "mike@mythik.co.uk";
    github = "MikePlayle";
    name = "Mike Playle";
  };
  mkazulak = {
    email = "kazulakm@gmail.com";
    github = "mulderr";
    name = "Maciej Kazulak";
  };
  mkg = {
    email = "mkg@vt.edu";
    github = "mkgvt";
    name = "Mark K Gardner";
  };
  mlieberman85 = {
    email = "mlieberman85@gmail.com";
    github = "mlieberman85";
    name = "Michael Lieberman";
  };
  mmahut = {
    email = "marek.mahut@gmail.com";
    github = "mmahut";
    name = "Marek Mahut";
  };
  mmlb = {
    email = "me.mmlb@mmlb.me";
    github = "mmlb";
    name = "Manuel Mendez";
  };
  mnacamura = {
    email = "m.nacamura@gmail.com";
    github = "mnacamura";
    name = "Mitsuhiro Nakamura";
  };
  moaxcp = {
    email = "moaxcp@gmail.com";
    github = "moaxcp";
    name = "John Mercier";
  };
  modulistic = {
    email = "modulistic@gmail.com";
    github = "modulistic";
    name = "Pablo Costa";
  };
  mog = {
    email = "mog-lists@rldn.net";
    github = "mogorman";
    name = "Matthew O'Gorman";
  };
  Mogria = {
    email = "m0gr14@gmail.com";
    github = "mogria";
    name = "Mogria";
  };
  monsieurp = {
    email = "monsieurp@gentoo.org";
    github = "monsieurp";
    name = "Patrice Clement";
  };
  montag451 = {
    email = "montag451@laposte.net";
    github = "montag451";
    name = "montag451";
  };
  moosingin3space = {
    email = "moosingin3space@gmail.com";
    github = "moosingin3space";
    name = "Nathan Moos";
  };
  moredread = {
    email = "code@apb.name";
    github = "moredread";
    name = "André-Patrick Bubel";
  };
  moretea = {
    email = "maarten@moretea.nl";
    github = "moretea";
    name = "Maarten Hoogendoorn";
  };
  MostAwesomeDude = {
    email = "cds@corbinsimpson.com";
    github = "MostAwesomeDude";
    name = "Corbin Simpson";
  };
  mounium = {
    email = "muoniurn@gmail.com";
    github = "mounium";
    name = "Katona László";
  };
  MP2E = {
    email = "MP2E@archlinux.us";
    github = "MP2E";
    name = "Cray Elliott";
  };
  mpcsh = {
    email = "m@mpc.sh";
    github = "mpcsh";
    name = "Mark Cohen";
  };
  mpickering = {
    email = "matthewtpickering@gmail.com";
    github = "mpickering";
    name = "Matthew Pickering";
  };
  mpscholten = {
    email = "marc@mpscholten.de";
    github = "mpscholten";
    name = "Marc Scholten";
  };
  mpsyco = {
    email = "fr.st-amour@gmail.com";
    github = "fstamour";
    name = "Francis St-Amour";
  };
  mredaelli = {
    email = "massimo@typish.io";
    github = "mredaelli";
    name = "Massimo Redaelli";
  };
  mrkkrp = {
    email = "markkarpov92@gmail.com";
    github = "mrkkrp";
    name = "Mark Karpov";
  };
  mrVanDalo = {
    email = "contact@ingolf-wagner.de";
    github = "mrVanDalo";
    name = "Ingolf Wanger";
  };
  msackman = {
    email = "matthew@wellquite.org";
    name = "Matthew Sackman";
  };
  mschneider = {
    email = "markus.schneider.sic+nix@gmail.com";
    name = "Markus Schneider";
  };
  mschristiansen = {
    email = "mikkel@rheosystems.com";
    github = "mschristiansen";
    name = "Mikkel Christiansen";
  };
  msiedlarek = {
    email = "mikolaj@siedlarek.pl";
    github = "msiedlarek";
    name = "Mikołaj Siedlarek";
  };
  mstarzyk = {
    email = "mstarzyk@gmail.com";
    github = "mstarzyk";
    name = "Maciek Starzyk";
  };
  msteen = {
    email = "emailmatthijs@gmail.com";
    github = "msteen";
    name = "Matthijs Steen";
  };
  mt-caret = {
    email = "mtakeda.enigsol@gmail.com";
    github = "mt-caret";
    name = "Masayuki Takeda";
  };
  MtP = {
    email = "marko.nixos@poikonen.de";
    github = "MtP76";
    name = "Marko Poikonen";
  };
  mtreskin = {
    email = "zerthurd@gmail.com";
    github = "Zert";
    name = "Max Treskin";
  };
  mudri = {
    email = "lamudri@gmail.com";
    github = "laMudri";
    name = "James Wood";
  };
  muflax = {
    email = "mail@muflax.com";
    github = "muflax";
    name = "Stefan Dorn";
  };
  mvnetbiz = {
    email = "mvnetbiz@gmail.com";
    github = "mvnetbiz";
    name = "Matt Votava";
  };
  mwilsoninsight = {
    email = "max.wilson@insight.com";
    github = "mwilsoninsight";
    name = "Max Wilson";
  };
  myrl = {
    email = "myrl.0xf@gmail.com";
    github = "myrl";
    name = "Myrl Hex";
  };
  nadrieril = {
    email = "nadrieril@gmail.com";
    github = "nadrieril";
    name = "Nadrieril Feneanar";
  };
  nalbyuites = {
    email = "ashijit007@gmail.com";
    github = "nalbyuites";
    name = "Ashijit Pramanik";
  };
  namore = {
    email = "namor@hemio.de";
    github = "namore";
    name = "Roman Naumann";
  };
  nand0p = {
    email = "nando@hex7.com";
    github = "nand0p";
    name = "Fernando Jose Pando";
  };
  Nate-Devv = {
    email = "natedevv@gmail.com";
    name = "Nathan Moore";
  };
  nathan-gs = {
    email = "nathan@nathan.gs";
    github = "nathan-gs";
    name = "Nathan Bijnens";
  };
  nckx = {
    email = "github@tobias.gr";
    github = "nckx";
    name = "Tobias Geerinckx-Rice";
  };
  ndowens = {
    email = "ndowens04@gmail.com";
    github = "ndowens";
    name = "Nathan Owens";
  };
  neeasade = {
    email = "nathanisom27@gmail.com";
    github = "neeasade";
    name = "Nathan Isom";
  };
  neonfuz = {
    email = "neonfuz@gmail.com";
    github = "neonfuz";
    name = "Sage Raflik";
  };
  nequissimus = {
    email = "tim@nequissimus.com";
    github = "nequissimus";
    name = "Tim Steinbach";
  };
  netixx = {
    email = "dev.espinetfrancois@gmail.com";
    github = "netixx";
    name = "François Espinet";
  };
  nikitavoloboev = {
    email = "nikita.voloboev@gmail.com";
    github = "nikitavoloboev";
    name = "Nikita Voloboev";
  };
  nfjinjing = {
    email = "nfjinjing@gmail.com";
    github = "nfjinjing";
    name = "Jinjing Wang";
  };
  nh2 = {
    email = "mail@nh2.me";
    github = "nh2";
    name = "Niklas Hambüchen";
  };
  nhooyr = {
    email = "anmol@aubble.com";
    github = "nhooyr";
    name = "Anmol Sethi";
  };
  nickhu = {
    email = "me@nickhu.co.uk";
    github = "nickhu";
    name = "Nick Hu";
  };
  nicknovitski = {
    email = "nixpkgs@nicknovitski.com";
    github = "nicknovitski";
    name = "Nick Novitski";
  };
  nico202 = {
    email = "anothersms@gmail.com";
    github = "nico202";
    name = "Nicolò Balzarotti";
  };
  NikolaMandic = {
    email = "nikola@mandic.email";
    github = "NikolaMandic";
    name = "Ratko Mladic";
  };
  ninjatrappeur = {
    email = "felix@alternativebit.fr";
    github = "ninjatrappeur";
    name = "Félix Baylac-Jacqué";
  };
  nioncode = {
    email = "nioncode+github@gmail.com";
    github = "nioncode";
    name = "Nicolas Schneider";
  };
  nipav = {
    email = "niko.pavlinek@gmail.com";
    github = "nipav";
    name = "Niko Pavlinek";
  };
  nixy = {
    email = "nixy@nixy.moe";
    github = "nixy";
    name = "Andrew R. M.";
  };
  nmattia = {
    email = "nicolas@nmattia.com";
    github = "nmattia";
    name = "Nicolas Mattia";
  };
  nocent = {
    email = "nocent@protonmail.ch";
    github = "nocent";
    name = "nocent";
  };
  nocoolnametom = {
    email = "nocoolnametom@gmail.com";
    github = "nocoolnametom";
    name = "Tom Doggett";
  };
  nomeata = {
    email = "mail@joachim-breitner.de";
    github = "nomeata";
    name = "Joachim Breitner";
  };
  noneucat = {
    email = "andy@lolc.at";
    github = "noneucat";
    name = "Andy Chun";
  };
  notthemessiah = {
    email = "brian.cohen.88@gmail.com";
    github = "notthemessiah";
    name = "Brian Cohen";
  };
  np = {
    email = "np.nix@nicolaspouillard.fr";
    github = "np";
    name = "Nicolas Pouillard";
  };
  nphilou = {
    email = "nphilou@gmail.com";
    github = "nphilou";
    name = "Philippe Nguyen";
  };
  nshalman = {
    email = "nahamu@gmail.com";
    github = "nshalman";
    name = "Nahum Shalman";
  };
  nslqqq = {
    email = "nslqqq@gmail.com";
    name = "Nikita Mikhailov";
  };
  nthorne = {
    email = "notrupertthorne@gmail.com";
    github = "nthorne";
    name = "Niklas Thörne";
  };
  numinit = {
    email = "me@numin.it";
    github = "numinit";
    name = "Morgan Jones";
  };
  nyanloutre = {
    email = "paul@nyanlout.re";
    github = "nyanloutre";
    name = "Paul Trehiou";
  };
  nyarly = {
    email = "nyarly@gmail.com";
    github = "nyarly";
    name = "Judson Lester";
  };
  nzhang-zh = {
    email = "n.zhang.hp.au@gmail.com";
    github = "nzhang-zh";
    name = "Ning Zhang";
  };
  obadz = {
    email = "obadz-nixos@obadz.com";
    github = "obadz";
    name = "obadz";
  };
  ocharles = {
    email = "ollie@ocharles.org.uk";
    github = "ocharles";
    name = "Oliver Charles";
  };
  odi = {
    email = "oliver.dunkl@gmail.com";
    github = "odi";
    name = "Oliver Dunkl";
  };
  offline = {
    email = "jaka@x-truder.net";
    github = "offlinehacker";
    name = "Jaka Hudoklin";
  };
  oida = {
    email = "oida@posteo.de";
    github = "oida";
    name = "oida";
  };
  okasu = {
    email = "oka.sux@gmail.com";
    name = "Okasu";
  };
  olcai = {
    email = "dev@timan.info";
    github = "olcai";
    name = "Erik Timan";
  };
  olejorgenb = {
    email = "olejorgenb@yahoo.no";
    github = "olejorgenb";
    name = "Ole Jørgen Brønner";
  };
  olynch = {
    email = "owen@olynch.me";
    github = "olynch";
    name = "Owen Lynch";
  };
  omnipotententity = {
    email = "omnipotententity@gmail.com";
    github = "omnipotententity";
    name = "Michael Reilly";
  };
  OPNA2608 = {
    email = "christoph.neidahl@gmail.com";
    github = "OPNA2608";
    name = "Christoph Neidahl";
  };
  orbekk = {
    email = "kjetil.orbekk@gmail.com";
    github = "orbekk";
    name = "KJ Ørbekk";
  };
  orbitz = {
    email = "mmatalka@gmail.com";
    github = "orbitz";
    name = "Malcolm Matalka";
  };
  orivej = {
    email = "orivej@gmx.fr";
    github = "orivej";
    name = "Orivej Desh";
  };
  osener = {
    email = "ozan@ozansener.com";
    github = "osener";
    name = "Ozan Sener";
  };
  otwieracz = {
    email = "slawek@otwiera.cz";
    github = "otwieracz";
    name = "Slawomir Gonet";
  };
  oxij = {
    email = "oxij@oxij.org";
    github = "oxij";
    name = "Jan Malakhovski";
    keys = [{
      longkeyid = "rsa2048/0x0E6CA66E5C557AA8";
      fingerprint = "514B B966 B46E 3565 0508  86E8 0E6C A66E 5C55 7AA8";
    }];
  };
  oyren = {
    email = "m.scheuren@oyra.eu";
    github = "oyren";
    name = "Moritz Scheuren";
  };
  pacien = {
    email = "b4gx3q.nixpkgs@pacien.net";
    github = "pacien";
    name = "Pacien Tran-Girard";
  };
  paddygord = {
    email = "pgpatrickgordon@gmail.com";
    github = "paddygord";
    name = "Patrick Gordon";
  };
  paholg = {
    email = "paho@paholg.com";
    github = "paholg";
    name = "Paho Lurie-Gregg";
  };
  pakhfn = {
    email = "pakhfn@gmail.com";
    github = "pakhfn";
    name = "Fedor Pakhomov";
  };
  panaeon = {
    email = "vitalii.voloshyn@gmail.com";
    github = "panaeon";
    name = "Vitalii Voloshyn";
  };
  pandaman = {
    email = "kointosudesuyo@infoseek.jp";
    github = "pandaman64";
    name = "pandaman";
  };
  paperdigits = {
    email = "mica@silentumbrella.com";
    github = "paperdigits";
    name = "Mica Semrick";
  };
  paraseba = {
    email = "paraseba@gmail.com";
    github = "paraseba";
    name = "Sebastian Galkin";
  };
  pashev = {
    email = "pashev.igor@gmail.com";
    github = "ip1981";
    name = "Igor Pashev";
  };
  patternspandemic = {
    email = "patternspandemic@live.com";
    github = "patternspandemic";
    name = "Brad Christensen";
  };
  pawelpacana = {
    email = "pawel.pacana@gmail.com";
    github = "pawelpacana";
    name = "Paweł Pacana";
  };
  pbogdan = {
    email = "ppbogdan@gmail.com";
    github = "pbogdan";
    name = "Piotr Bogdan";
  };
  pcarrier = {
    email = "pc@rrier.ca";
    github = "pcarrier";
    name = "Pierre Carrier";
  };
  periklis = {
    email = "theopompos@gmail.com";
    github = "periklis";
    name = "Periklis Tsirakidis";
  };
  pesterhazy = {
    email = "pesterhazy@gmail.com";
    github = "pesterhazy";
    name = "Paulus Esterhazy";
  };
  petabyteboy = {
    email = "me@pbb.lc";
    github = "petabyteboy";
    name = "Milan Pässler";
  };
  peterhoeg = {
    email = "peter@hoeg.com";
    github = "peterhoeg";
    name = "Peter Hoeg";
  };
  peterromfeldhk = {
    email = "peter.romfeld.hk@gmail.com";
    github = "peterromfeldhk";
    name = "Peter Romfeld";
  };
  peti = {
    email = "simons@cryp.to";
    github = "peti";
    name = "Peter Simons";
  };
  philandstuff = {
    email = "philip.g.potter@gmail.com";
    github = "philandstuff";
    name = "Philip Potter";
  };
  phile314 = {
    email = "nix@314.ch";
    github = "phile314";
    name = "Philipp Hausmann";
  };
  Phlogistique = {
    email = "noe.rubinstein@gmail.com";
    github = "Phlogistique";
    name = "Noé Rubinstein";
  };
  phreedom = {
    email = "phreedom@yandex.ru";
    github = "phreedom";
    name = "Evgeny Egorochkin";
  };
  phryneas = {
    email = "mail@lenzw.de";
    github = "phryneas";
    name = "Lenz Weber";
  };
  phunehehe = {
    email = "phunehehe@gmail.com";
    github = "phunehehe";
    name = "Hoang Xuan Phu";
  };
  pierrechevalier83 = {
    email = "pierrechevalier83@gmail.com";
    github = "pierrechevalier83";
    name = "Pierre Chevalier";
  };
  pierreis = {
    email = "pierre@pierre.is";
    github = "pierreis";
    name = "Pierre Matri";
  };
  pierrer = {
    email = "pierrer@pi3r.be";
    github = "pierrer";
    name = "Pierre Radermecker";
  };
  pierron = {
    email = "nixos@nbp.name";
    github = "nbp";
    name = "Nicolas B. Pierron";
  };
  piotr = {
    email = "ppietrasa@gmail.com";
    name = "Piotr Pietraszkiewicz";
  };
  pjbarnoy = {
    email = "pjbarnoy@gmail.com";
    github = "pjbarnoy";
    name = "Perry Barnoy";
  };
  pjones = {
    email = "pjones@devalot.com";
    github = "pjones";
    name = "Peter Jones";
  };
  pkmx = {
    email = "pkmx.tw@gmail.com";
    github = "pkmx";
    name = "Chih-Mao Chen";
  };
  plchldr = {
    email = "mail@oddco.de";
    github = "plchldr";
    name = "Jonas Beyer";
  };
  plcplc = {
    email = "plcplc@gmail.com";
    github = "plcplc";
    name = "Philip Lykke Carlsen";
  };
  plumps = {
    email = "maks.bronsky@web.de";
    github = "plumps";
    name = "Maksim Bronsky";
  };
  pmahoney = {
    email = "pat@polycrystal.org";
    github = "pmahoney";
    name = "Patrick Mahoney";
  };
  pmeunier = {
    email = "pierre-etienne.meunier@inria.fr";
    github = "P-E-Meunier";
    name = "Pierre-Étienne Meunier";
  };
  pmiddend = {
    email = "pmidden@secure.mailbox.org";
    github = "pmiddend";
    name = "Philipp Middendorf";
  };
  pmyjavec = {
    email = "pauly@myjavec.com";
    github = "pmyjavec";
    name = "Pauly Myjavec";
  };
  pnelson = {
    email = "me@pnelson.ca";
    github = "pnelson";
    name = "Philip Nelson";
  };
  pneumaticat = {
    email = "kevin@potatofrom.space";
    github = "pneumaticat";
    name = "Kevin Liu";
  };
  polyrod = {
    email = "dc1mdp@gmail.com";
    github = "polyrod";
    name = "Maurizio Di Pietro";
  };
  pombeirp = {
    email = "nix@endgr.33mail.com";
    github = "PombeirP";
    name = "Pedro Pombeiro";
  };
  pradeepchhetri = {
    email = "pradeep.chhetri89@gmail.com";
    github = "pradeepchhetri";
    name = "Pradeep Chhetri";
  };
  prikhi = {
    email = "pavan.rikhi@gmail.com";
    github = "prikhi";
    name = "Pavan Rikhi";
  };
  primeos = {
    email = "dev.primeos@gmail.com";
    github = "primeos";
    name = "Michael Weiss";
    keys = [
      { longkeyid = "ed25519/0x130826A6C2A389FD"; # Git only
        fingerprint = "86A7 4A55 07D0 58D1 322E  37FD 1308 26A6 C2A3 89FD";
      }
      { longkeyid = "rsa3072/0xBCA9943DD1DF4C04"; # Email, etc.
        fingerprint = "AF85 991C C950 49A2 4205  1933 BCA9 943D D1DF 4C04";
      }
    ];
  };
  Profpatsch = {
    email = "mail@profpatsch.de";
    github = "Profpatsch";
    name = "Profpatsch";
  };
  proglodyte = {
    email = "proglodyte23@gmail.com";
    github = "proglodyte";
    name = "Proglodyte";
  };
  prusnak = {
    email = "stick@gk2.sk";
    github = "prusnak";
    name = "Pavol Rusnak";
  };
  pshendry = {
    email = "paul@pshendry.com";
    github = "pshendry";
    name = "Paul Hendry";
  };
  psibi = {
    email = "sibi@psibi.in";
    github = "psibi";
    name = "Sibi";
  };
  pstn = {
    email = "philipp@xndr.de";
    name = "Philipp Steinpaß";
  };
  pSub = {
    email = "mail@pascal-wittmann.de";
    github = "pSub";
    name = "Pascal Wittmann";
  };
  psyanticy = {
    email = "iuns@outlook.fr";
    github = "PsyanticY";
    name = "Psyanticy";
  };
  ptival = {
    email = "valentin.robert.42@gmail.com";
    github = "Ptival";
    name = "Valentin Robert";
  };
  ptrhlm = {
    email = "ptrhlm0@gmail.com";
    github = "ptrhlm";
    name = "Piotr Halama";
  };
  puffnfresh = {
    email = "brian@brianmckenna.org";
    github = "puffnfresh";
    name = "Brian McKenna";
  };
  pxc = {
    email = "patrick.callahan@latitudeengineering.com";
    name = "Patrick Callahan";
  };
  pyrolagus = {
    email = "pyrolagus@gmail.com";
    github = "PyroLagus";
    name = "Danny Bautista";
  };
  q3k = {
    email = "q3k@q3k.org";
    github = "q3k";
    name = "Serge Bazanski";
  };
  qknight = {
    email = "js@lastlog.de";
    github = "qknight";
    name = "Joachim Schiele";
  };
  qoelet = {
    email = "kenny@machinesung.com";
    github = "qoelet";
    name = "Kenny Shen";
  };
  qyliss = {
    email = "hi@alyssa.is";
    github = "alyssais";
    name = "Alyssa Ross";
    keys = [{
      longkeyid = "rsa4096/736CCDF9EF51BD97";
      fingerprint = "7573 56D7 79BB B888 773E  415E 736C CDF9 EF51 BD97";
    }];
  };
  rafaelgg = {
    email = "rafael.garcia.gallego@gmail.com";
    github = "rafaelgg";
    name = "Rafael García";
  };
  raquelgb = {
    email = "raquel.garcia.bautista@gmail.com";
    github = "raquelgb";
    name = "Raquel García";
  };
  ragge = {
    email = "r.dahlen@gmail.com";
    github = "ragnard";
    name = "Ragnar Dahlen";
  };
  ralith = {
    email = "ben.e.saunders@gmail.com";
    github = "ralith";
    name = "Benjamin Saunders";
  };
  ramkromberg = {
    email = "ramkromberg@mail.com";
    github = "ramkromberg";
    name = "Ram Kromberg";
  };
  rardiol = {
    email = "ricardo.ardissone@gmail.com";
    github = "rardiol";
    name = "Ricardo Ardissone";
  };
  rasendubi = {
    email = "rasen.dubi@gmail.com";
    github = "rasendubi";
    name = "Alexey Shmalko";
  };
  raskin = {
    email = "7c6f434c@mail.ru";
    github = "7c6f434c";
    name = "Michael Raskin";
  };
  ravloony = {
    email = "ravloony@gmail.com";
    name = "Tom Macdonald";
  };
  rawkode = {
    email = "david.andrew.mckay@gmail.com";
    github = "rawkode";
    name = "David McKay";
  };
  razvan = {
    email = "razvan.panda@gmail.com";
    github = "razvan-panda";
    name = "Răzvan Flavius Panda";
  };
  rbasso = {
    email = "rbasso@sharpgeeks.net";
    github = "rbasso";
    name = "Rafael Basso";
  };
  rbrewer = {
    email = "rwb123@gmail.com";
    github = "rbrewer123";
    name = "Rob Brewer";
  };
  rdnetto = {
    email = "rdnetto@gmail.com";
    github = "rdnetto";
    name = "Reuben D'Netto";
  };
  redbaron = {
    email = "ivanov.maxim@gmail.com";
    github = "redbaron";
    name = "Maxim Ivanov";
  };
  redfish64 = {
    email = "engler@gmail.com";
    github = "redfish64";
    name = "Tim Engler";
  };
  redvers = {
    email = "red@infect.me";
    github = "redvers";
    name = "Redvers Davies";
  };
  refnil = {
    email = "broemartino@gmail.com";
    github = "refnil";
    name = "Martin Lavoie";
  };
  regnat = {
    email = "regnat@regnat.ovh";
    github = "regnat";
    name = "Théophane Hufschmitt";
  };
  relrod = {
    email = "ricky@elrod.me";
    github = "relrod";
    name = "Ricky Elrod";
  };
  rembo10 = {
    email = "rembo10@users.noreply.github.com";
    github = "rembo10";
    name = "rembo10";
  };
  renatoGarcia = {
    email = "fgarcia.renato@gmail.com";
    github = "renatoGarcia";
    name = "Renato Garcia";
  };
  rencire = {
    email = "546296+rencire@users.noreply.github.com";
    github = "rencire";
    name = "Eric Ren";
  };
  renzo = {
    email = "renzocarbonara@gmail.com";
    github = "k0001";
    name = "Renzo Carbonara";
  };
  retrry = {
    email = "retrry@gmail.com";
    github = "retrry";
    name = "Tadas Barzdžius";
  };
  rexim = {
    email = "reximkut@gmail.com";
    github = "rexim";
    name = "Alexey Kutepov";
  };
  rht = {
    email = "rhtbot@protonmail.com";
    github = "rht";
    name = "rht";
  };
  richardipsum = {
    email = "richardipsum@fastmail.co.uk";
    github = "richardipsum";
    name = "Richard Ipsum";
  };
  rick68 = {
    email = "rick68@gmail.com";
    github = "rick68";
    name = "Wei-Ming Yang";
  };
  rickynils = {
    email = "rickynils@gmail.com";
    github = "rickynils";
    name = "Rickard Nilsson";
  };
  ris = {
    email = "code@humanleg.org.uk";
    github = "risicle";
    name = "Robert Scott";
  };
  rittelle = {
    email = "rittelle@posteo.de";
    github = "rittelle";
    name = "Lennart Rittel";
  };
  rixed = {
    email = "rixed-github@happyleptic.org";
    github = "rixed";
    name = "Cedric Cellier";
  };
  rkoe = {
    email = "rk@simple-is-better.org";
    github = "rkoe";
    name = "Roland Koebler";
  };
  rlupton20 = {
    email = "richard.lupton@gmail.com";
    github = "rlupton20";
    name = "Richard Lupton";
  };
  rnhmjoj = {
    email = "micheleguerinirocco@me.com";
    github = "rnhmjoj";
    name = "Michele Guerini Rocco";
  };
  rob = {
    email = "rob.vermaas@gmail.com";
    github = "rbvermaa";
    name = "Rob Vermaas";
  };
  robberer = {
    email = "robberer@freakmail.de";
    github = "robberer";
    name = "Longrin Wischnewski";
  };
  robbinch = {
    email = "robbinch33@gmail.com";
    github = "robbinch";
    name = "Robbin C.";
  };
  roberth = {
    email = "nixpkgs@roberthensing.nl";
    github = "roberth";
    name = "Robert Hensing";
  };
  robertodr = {
    email = "roberto.diremigio@gmail.com";
    github = "robertodr";
    name = "Roberto Di Remigio";
  };
  robgssp = {
    email = "robgssp@gmail.com";
    github = "robgssp";
    name = "Rob Glossop";
  };
  roblabla = {
    email = "robinlambertz+dev@gmail.com";
    github = "roblabla";
    name = "Robin Lambertz";
  };
  roconnor = {
    email = "roconnor@theorem.ca";
    github = "roconnor";
    name = "Russell O'Connor";
  };
  romildo = {
    email = "malaquias@gmail.com";
    github = "romildo";
    name = "José Romildo Malaquias";
  };
  rongcuid = {
    email = "rongcuid@outlook.com";
    github = "rongcuid";
    name = "Rongcui Dong";
  };
  roosemberth = {
    email = "roosembert.palacios+nixpkgs@gmail.com";
    github = "roosemberth";
    name = "Roosembert (Roosemberth) Palacios";
  };
  royneary = {
    email = "christian@ulrich.earth";
    github = "royneary";
    name = "Christian Ulrich";
  };
  rprospero = {
    email = "rprospero+nix@gmail.com";
    github = "rprospero";
    name = "Adam Washington";
  };
  rps = {
    email = "robbpseaton@gmail.com";
    github = "robertseaton";
    name = "Robert P. Seaton";
  };
  rszibele = {
    email = "richard@szibele.com";
    github = "rszibele";
    name = "Richard Szibele";
  };
  rtreffer = {
    email = "treffer+nixos@measite.de";
    github = "rtreffer";
    name = "Rene Treffer";
  };
  rushmorem = {
    email = "rushmore@webenchanter.com";
    github = "rushmorem";
    name = "Rushmore Mushambi";
  };
  ruuda = {
    email = "dev+nix@veniogames.com";
    github = "ruuda";
    name = "Ruud van Asseldonk";
  };
  rvl = {
    email = "dev+nix@rodney.id.au";
    github = "rvl";
    name = "Rodney Lorrimar";
  };
  rvlander = {
    email = "rvlander@gaetanandre.eu";
    github = "rvlander";
    name = "Gaëtan André";
  };
  rvolosatovs = {
    email = "rvolosatovs@riseup.net";
    github = "rvolosatovs";
    name = "Roman Volosatovs";
  };
  ryanartecona = {
    email = "ryanartecona@gmail.com";
    github = "ryanartecona";
    name = "Ryan Artecona";
  };
  ryansydnor = {
    email = "ryan.t.sydnor@gmail.com";
    github = "ryansydnor";
    name = "Ryan Sydnor";
  };
  ryantm = {
    email = "ryan@ryantm.com";
    github = "ryantm";
    name = "Ryan Mulligan";
  };
  ryantrinkle = {
    email = "ryan.trinkle@gmail.com";
    github = "ryantrinkle";
    name = "Ryan Trinkle";
  };
  rybern = {
    email = "ryan.bernstein@columbia.edu";
    github = "rybern";
    name = "Ryan Bernstein";
  };
  rycee = {
    email = "robert@rycee.net";
    github = "rycee";
    name = "Robert Helgesson";
  };
  ryneeverett = {
    email = "ryneeverett@gmail.com";
    github = "ryneeverett";
    name = "Ryne Everett";
  };
  rzetterberg = {
    email = "richard.zetterberg@gmail.com";
    github = "rzetterberg";
    name = "Richard Zetterberg";
  };
  s1lvester = {
    email = "s1lvester@bockhacker.me";
    github = "s1lvester";
    name = "Markus Silvester";
  };
  samdroid-apps = {
    email = "sam@sam.today";
    github = "samdroid-apps";
    name = "Sam Parkinson";
  };
  samrose = {
   email = "samuel.rose@gmail.com";
   github = "samrose";
   name = "Sam Rose";
  };
  samueldr = {
    email = "samuel@dionne-riel.com";
    github = "samueldr";
    name = "Samuel Dionne-Riel";
  };
  samuelrivas = {
    email = "samuelrivas@gmail.com";
    github = "samuelrivas";
    name = "Samuel Rivas";
  };
  sander = {
    email = "s.vanderburg@tudelft.nl";
    github = "svanderburg";
    name = "Sander van der Burg";
  };
  sargon = {
    email = "danielehlers@mindeye.net";
    github = "sargon";
    name = "Daniel Ehlers";
  };
  saschagrunert = {
    email = "mail@saschagrunert.de";
    github = "saschagrunert";
    name = "Sascha Grunert";
  };
  sauyon = {
    email = "s@uyon.co";
    github = "sauyon";
    name = "Sauyon Lee";
  };
  sb0 = {
    email = "sb@m-labs.hk";
    github = "sbourdeauducq";
    name = "Sébastien Bourdeauducq";
  };
  sboosali = {
    email = "SamBoosalis@gmail.com";
    github = "sboosali";
    name = "Sam Boosalis";
  };
  scalavision = {
    email = "scalavision@gmail.com";
    github = "scalavision";
    name = "Tom Sorlie";
  };
  schmitthenner = {
    email = "development@schmitthenner.eu";
    github = "fkz";
    name = "Fabian Schmitthenner";
  };
  schmittlauch = {
    email = "t.schmittlauch+nixos@orlives.de";
    github = "schmittlauch";
  };
  schneefux = {
    email = "schneefux+nixos_pkg@schneefux.xyz";
    github = "schneefux";
    name = "schneefux";
  };
  schristo = {
    email = "schristopher@konputa.com";
    name = "Scott Christopher";
  };
  scode = {
    email = "peter.schuller@infidyne.com";
    github = "scode";
    name = "Peter Schuller";
  };
  scolobb = {
    email = "sivanov@colimite.fr";
    github = "scolobb";
    name = "Sergiu Ivanov";
  };
  screendriver = {
    email = "nix@echooff.de";
    github = "screendriver";
    name = "Christian Rackerseder";
  };
  Scriptkiddi = {
    email = "nixos@scriptkiddi.de";
    github = "scriptkiddi";
    name = "Fritz Otlinghaus";
  };
  sdll = {
    email = "sasha.delly@gmail.com";
    github = "sdll";
    name = "Sasha Illarionov";
  };
  SeanZicari = {
    email = "sean.zicari@gmail.com";
    github = "SeanZicari";
    name = "Sean Zicari";
  };
  sellout = {
    email = "greg@technomadic.org";
    github = "sellout";
    name = "Greg Pfeil";
  };
  sengaya = {
    email = "tlo@sengaya.de";
    github = "sengaya";
    name = "Thilo Uttendorfer";
  };
  sephalon = {
    email = "me@sephalon.net";
    github = "sephalon";
    name = "Stefan Wiehler";
  };
  sepi = {
    email = "raffael@mancini.lu";
    github = "sepi";
    name = "Raffael Mancini";
  };
  seppeljordan = {
    email = "sebastian.jordan.mail@googlemail.com";
    github = "seppeljordan";
    name = "Sebastian Jordan";
  };
  seqizz = {
    email = "seqizz@gmail.com";
    github = "seqizz";
    name = "Gurkan Gur";
  };
  sfrijters = {
    email = "sfrijters@gmail.com";
    github = "sfrijters";
    name = "Stefan Frijters";
  };
  sgraf = {
    email = "sgraf1337@gmail.com";
    github = "sgraf812";
    name = "Sebastian Graf";
  };
  shanemikel = {
    email = "shanemikel1@gmail.com";
    github = "shanemikel";
    name = "Shane Pearlman";
  };
  shawndellysse = {
    email = "sdellysse@gmail.com";
    github = "shawndellysse";
    name = "Shawn Dellysse";
  };
  shazow = {
    email = "andrey.petrov@shazow.net";
    github = "shazow";
    name = "Andrey Petrov";
  };
  sheenobu = {
    email = "sheena.artrip@gmail.com";
    github = "sheenobu";
    name = "Sheena Artrip";
  };
  sheganinans = {
    email = "sheganinans@gmail.com";
    github = "sheganinans";
    name = "Aistis Raulinaitis";
  };
  shell = {
    email = "cam.turn@gmail.com";
    github = "VShell";
    name = "Shell Turner";
  };
  shlevy = {
    email = "shea@shealevy.com";
    github = "shlevy";
    name = "Shea Levy";
  };
  shmish111 = {
    email = "shmish111@gmail.com";
    github = "shmish111";
    name = "David Smith";
  };
  shou = {
    email = "x+g@shou.io";
    github = "Shou";
    name = "Benedict Aas";
  };
  siddharthist = {
    email = "langston.barrett@gmail.com";
    github = "siddharthist";
    name = "Langston Barrett";
  };
  siers = {
    email = "veinbahs+nixpkgs@gmail.com";
    github = "siers";
    name = "Raitis Veinbahs";
  };
  sifmelcara = {
    email = "ming@culpring.com";
    github = "sifmelcara";
    name = "Ming Chuan";
  };
  sigma = {
    email = "yann.hodique@gmail.com";
    github = "sigma";
    name = "Yann Hodique";
  };
  simonvandel = {
    email = "simon.vandel@gmail.com";
    github = "simonvandel";
    name = "Simon Vandel Sillesen";
  };
  sivteck = {
    email = "sivaram1992@gmail.com";
    github = "sivteck";
    name = "Sivaram Balakrishnan";
  };
  sjagoe = {
    email = "simon@simonjagoe.com";
    github = "sjagoe";
    name = "Simon Jagoe";
  };
  sjau = {
    email = "nixos@sjau.ch";
    github = "sjau";
    name = "Stephan Jau";
  };
  sjmackenzie = {
    email = "setori88@gmail.com";
    github = "sjmackenzie";
    name = "Stewart Mackenzie";
  };
  sjourdois = {
    email = "sjourdois@gmail.com";
    name = "Stéphane ‘kwisatz’ Jourdois";
  };
  skeidel = {
    email = "svenkeidel@gmail.com";
    github = "svenkeidel";
    name = "Sven Keidel";
  };
  skrzyp = {
    email = "jot.skrzyp@gmail.com";
    name = "Jakub Skrzypnik";
  };
  sleexyz = {
    email = "freshdried@gmail.com";
    github = "sleexyz";
    name = "Sean Lee";
  };
  smakarov = {
    email = "setser200018@gmail.com";
    github = "setser";
    name = "Sergey Makarov";
    keys = [{
      longkeyid = "rsa2048/6AA23A1193B7064B";
      fingerprint = "6F8A 18AE 4101 103F 3C54  24B9 6AA2 3A11 93B7 064B";
    }];
  };
  smaret = {
    email = "sebastien.maret@icloud.com";
    github = "smaret";
    name = "Sébastien Maret";
    keys = [{
      longkeyid = "rsa4096/0x86E30E5A0F5FC59C";
      fingerprint = "4242 834C D401 86EF 8281  4093 86E3 0E5A 0F5F C59C";
    }];
  };
  smironov = {
    email = "grrwlf@gmail.com";
    github = "grwlf";
    name = "Sergey Mironov";
  };
  sna = {
    email = "abouzahra.9@wright.edu";
    github = "s-na";
    name = "S. Nordin Abouzahra";
  };
  snaar = {
    email = "snaar@snaar.net";
    github = "snaar";
    name = "Serguei Narojnyi";
  };
  snyh = {
    email = "snyh@snyh.org";
    github = "snyh";
    name = "Xia Bin";
  };
  solson = {
    email = "scott@solson.me";
    github = "solson";
    name = "Scott Olson";
  };
  sondr3 = {
    email = "nilsen.sondre@gmail.com";
    github = "sondr3";
    name = "Sondre Nilsen";
    keys = [{
      longkeyid = "ed25519/0x25676BCBFFAD76B1";
      fingerprint = "0EC3 FA89 EFBA B421 F82E  40B0 2567 6BCB FFAD 76B1";
    }];
  };
  sorki = {
    email = "srk@48.io";
    github = "sorki";
    name = "Richard Marko";
  };
  sorpaas = {
    email = "hi@that.world";
    github = "sorpaas";
    name = "Wei Tang";
  };
  spacefrogg = {
    email = "spacefrogg-nixos@meterriblecrew.net";
    github = "spacefrogg";
    name = "Michael Raitza";
  };
  spacekookie = {
    email = "kookie@spacekookie.de";
    github = "spacekookie";
    name = "Katharina Fey";
  };
  spencerjanssen = {
    email = "spencerjanssen@gmail.com";
    github = "spencerjanssen";
    name = "Spencer Janssen";
  };
  spinus = {
    email = "tomasz.czyz@gmail.com";
    github = "spinus";
    name = "Tomasz Czyż";
  };
  sprock = {
    email = "rmason@mun.ca";
    github = "sprock";
    name = "Roger Mason";
  };
  spwhitt = {
    email = "sw@swhitt.me";
    github = "spwhitt";
    name = "Spencer Whitt";
  };
  srghma = {
    email = "srghma@gmail.com";
    github = "srghma";
    name = "Sergei Khoma";
  };
  srgom = {
    email = "srgom@users.noreply.github.com";
    github = "srgom";
    name = "SRGOM";
  };
  srhb = {
    email = "sbrofeldt@gmail.com";
    github = "srhb";
    name = "Sarah Brofeldt";
  };
  SShrike = {
    email = "severen@shrike.me";
    github = "severen";
    name = "Severen Redwood";
  };
  stephenmw = {
    email = "stephen@q5comm.com";
    github = "stephenmw";
    name = "Stephen Weinberg";
  };
  sternenseemann = {
    email = "post@lukasepple.de";
    github = "sternenseemann";
    name = "Lukas Epple";
  };
  stesie = {
    email = "stesie@brokenpipe.de";
    github = "stesie";
    name = "Stefan Siegl";
  };
  steve-chavez = {
    email = "stevechavezast@gmail.com";
    github = "steve-chavez";
    name = "Steve Chávez";
  };
  steveej = {
    email = "mail@stefanjunker.de";
    github = "steveej";
    name = "Stefan Junker";
  };
  StijnDW = {
    email = "stekke@airmail.cc";
    github = "StijnDW";
    name = "Stijn DW";
  };
  StillerHarpo = {
    email = "florianengel39@gmail.com";
    github = "StillerHarpo";
    name = "Florian Engel";
  };
  stites = {
    email = "sam@stites.io";
    github = "stites";
    name = "Sam Stites";
  };
  stumoss = {
    email = "samoss@gmail.com";
    github = "stumoss";
    name = "Stuart Moss";
  };
  suhr = {
    email = "suhr@i2pmail.org";
    github = "suhr";
    name = "Сухарик";
  };
  SuprDewd = {
    email = "suprdewd@gmail.com";
    github = "SuprDewd";
    name = "Bjarki Ágúst Guðmundsson";
  };
  suvash = {
    email = "suvash+nixpkgs@gmail.com";
    github = "suvash";
    name = "Suvash Thapaliya";
  };
  sveitser = {
    email = "sveitser@gmail.com";
    github = "sveitser";
    name = "Mathis Antony";
  };
  svsdep = {
    email = "svsdep@gmail.com";
    github = "svsdep";
    name = "Vasyl Solovei";
  };
  swarren83 = {
    email = "shawn.w.warren@gmail.com";
    github = "swarren83";
    name = "Shawn Warren";
  };
  swdunlop = {
    email = "swdunlop@gmail.com";
    github = "swdunlop";
    name = "Scott W. Dunlop";
  };
  swflint = {
    email = "swflint@flintfam.org";
    github = "swflint";
    name = "Samuel W. Flint";
  };
  swistak35 = {
    email = "me@swistak35.com";
    github = "swistak35";
    name = "Rafał Łasocha";
  };
  symphorien = {
    email = "symphorien_nixpkgs@xlumurb.eu";
    github = "symphorien";
    name = "Guillaume Girol";
  };
  synthetica = {
    email = "nix@hilhorst.be";
    github = "Synthetica9";
    name = "Patrick Hilhorst";
  };
  szczyp = {
    email = "qb@szczyp.com";
    github = "szczyp";
    name = "Szczyp";
  };
  sztupi = {
    email = "attila.sztupak@gmail.com";
    github = "sztupi";
    name = "Attila Sztupak";
  };
  t184256 = {
    email = "monk@unboiled.info";
    github = "t184256";
    name = "Alexander Sosedkin";
  };
  tadeokondrak = {
    email = "me@tadeo.ca";
    github = "tadeokondrak";
    name = "Tadeo Kondrak";
    keys = [{
      longkeyid = "ed25519/0xFBE607FCC49516D3";
      fingerprint = "0F2B C0C7 E77C 5B42 AC5B  4C18 FBE6 07FC C495 16D3";
    }];
  };
  tadfisher = {
    email = "tadfisher@gmail.com";
    github = "tadfisher";
    name = "Tad Fisher";
  };
  taeer = {
    email = "taeer@necsi.edu";
    github = "Radvendii";
    name = "Taeer Bar-Yam";
  };
  taha = {
    email = "xrcrod@gmail.com";
    github = "tgharib";
    name = "Taha Gharib";
  };
  tailhook = {
    email = "paul@colomiets.name";
    github = "tailhook";
    name = "Paul Colomiets";
  };
  taketwo = {
    email = "alexandrov88@gmail.com";
    github = "taketwo";
    name = "Sergey Alexandrov";
  };
  takikawa = {
    email = "asumu@igalia.com";
    github = "takikawa";
    name = "Asumu Takikawa";
  };
  taktoa = {
    email = "taktoa@gmail.com";
    github = "taktoa";
    name = "Remy Goldschmidt";
  };
  taku0 = {
    email = "mxxouy6x3m_github@tatapa.org";
    github = "taku0";
    name = "Takuo Yonezawa";
  };
  talyz = {
    email = "kim.lindberger@gmail.com";
    github = "talyz";
    name = "Kim Lindberger";
  };
  taneb = {
    email = "nvd1234@gmail.com";
    github = "Taneb";
    name = "Nathan van Doorn";
  };
  tari = {
    email = "peter@taricorp.net";
    github = "tari";
    name = "Peter Marheine";
  };
  tavyc = {
    email = "octavian.cerna@gmail.com";
    github = "tavyc";
    name = "Octavian Cerna";
  };
  tazjin = {
    email = "mail@tazj.in";
    github = "tazjin";
    name = "Vincent Ambo";
  };
  tbenst = {
    email = "nix@tylerbenster.com";
    github = "tbenst";
    name = "Tyler Benster";
  };
  teh = {
    email = "tehunger@gmail.com";
    github = "teh";
    name = "Tom Hunger";
  };
  telotortium = {
    email = "rirelan@gmail.com";
    github = "telotortium";
    name = "Robert Irelan";
  };
  teozkr = {
    email = "teo@nullable.se";
    github = "teozkr";
    name = "Teo Klestrup Röijezon";
  };
  terlar = {
    email = "terlar@gmail.com";
    github = "terlar";
    name = "Terje Larsen";
  };
  tesq0 = {
    email = "mikolaj.galkowski@gmail.com";
    github = "tesq0";
    name = "Mikolaj Galkowski";
  };
  teto = {
    email = "mcoudron@hotmail.com";
    github = "teto";
    name = "Matthieu Coudron";
  };
  tex = {
    email = "milan.svoboda@centrum.cz";
    github = "tex";
    name = "Milan Svoboda";
  };
  tg-x = {
    email = "*@tg-x.net";
    github = "tg-x";
    name = "TG ⊗ Θ";
  };
  thall = {
    email = "niclas.thall@gmail.com";
    github = "thall";
    name = "Niclas Thall";
  };
  thammers = {
    email = "jawr@gmx.de";
    github = "tobias-hammerschmidt";
    name = "Tobias Hammerschmidt";
  };
  thanegill = {
    email = "me@thanegill.com";
    github = "thanegill";
    name = "Thane Gill";
  };
  the-kenny = {
    email = "moritz@tarn-vedra.de";
    github = "the-kenny";
    name = "Moritz Ulrich";
  };
  thedavidmeister = {
    email = "thedavidmeister@gmail.com";
    github = "thedavidmeister";
    name = "David Meister";
  };
  thefloweringash = {
    email = "lorne@cons.org.nz";
    github = "thefloweringash";
    name = "Andrew Childs";
  };
  thesola10 = {
    email = "thesola10@bobile.fr";
    github = "thesola10";
    keys = [{
      longkeyid = "rsa4096/0x89245619BEBB95BA";
      fingerprint = "1D05 13A6 1AC4 0D8D C6D6  5F2C 8924 5619 BEBB 95BA";
    }];
    name = "Karim Vergnes";
  };
  theuni = {
    email = "ct@flyingcircus.io";
    github = "ctheune";
    name = "Christian Theune";
  };
  thiagokokada = {
    email = "thiagokokada@gmail.com";
    github = "thiagokokada";
    name = "Thiago K. Okada";
  };
  ThomasMader = {
    email = "thomas.mader@gmail.com";
    github = "ThomasMader";
    name = "Thomas Mader";
  };
  thoughtpolice = {
    email = "aseipp@pobox.com";
    github = "thoughtpolice";
    name = "Austin Seipp";
  };
  thpham = {
    email = "thomas.pham@ithings.ch";
    github = "thpham";
    name = "Thomas Pham";
  };
  tilpner = {
    email = "till@hoeppner.ws";
    github = "tilpner";
    name = "Till Höppner";
  };
  timbertson = {
    email = "tim@gfxmonk.net";
    github = "timbertson";
    name = "Tim Cuthbertson";
  };
  timokau = {
    email = "timokau@zoho.com";
    github = "timokau";
    name = "Timo Kaufmann";
  };
  timor = {
    email = "timor.dd@googlemail.com";
    github = "timor";
    name = "timor";
  };
  timput = {
    email = "tim@timput.com";
    github = "TimPut";
    name = "Tim Put";
  };
  tiramiseb = {
    email = "sebastien@maccagnoni.eu";
    github = "tiramiseb";
    name = "Sébastien Maccagnoni";
  };
  titanous = {
    email = "jonathan@titanous.com";
    github = "titanous";
    name = "Jonathan Rudenberg";
  };
  tmplt = {
    email = "tmplt@dragons.rocks";
    github = "tmplt";
    name = "Viktor";
  };
  tnias = {
    email = "phil@grmr.de";
    github = "tnias";
    name = "Philipp Bartsch";
  };
  tobim = {
    email = "nix@tobim.fastmail.fm";
    github = "tobimpub";
    name = "Tobias Mayer";
  };
  tohl = {
    email = "tom@logand.com";
    github = "tohl";
    name = "Tomas Hlavaty";
  };
  tokudan = {
    email = "git@danielfrank.net";
    github = "tokudan";
    name = "Daniel Frank";
  };
  tomahna = {
    email = "kevin.rauscher@tomahna.fr";
    github = "Tomahna";
    name = "Kevin Rauscher";
  };
  tomberek = {
    email = "tomberek@gmail.com";
    github = "tomberek";
    name = "Thomas Bereknyei";
  };
  tomsmeets = {
    email = "tom.tsmeets@gmail.com";
    github = "tomsmeets";
    name = "Tom Smeets";
  };
  toonn = {
    email = "nnoot@toonn.io";
    github = "toonn";
    name = "Toon Nolten";
  };
  travisbhartwell = {
    email = "nafai@travishartwell.net";
    github = "travisbhartwell";
    name = "Travis B. Hartwell";
  };
  treemo = {
    email = "matthieu.chevrier@treemo.fr";
    github = "treemo";
    name = "Matthieu Chevrier";
  };
  trevorj = {
    email = "nix@trevor.joynson.io";
    github = "akatrevorjay";
    name = "Trevor Joynson";
  };
  trino = {
    email = "muehlhans.hubert@ekodia.de";
    github = "hmuehlhans";
    name = "Hubert Mühlhans";
  };
  troydm = {
    email = "d.geurkov@gmail.com";
    github = "troydm";
    name = "Dmitry Geurkov";
  };
  tstrobel = {
    email = "4ZKTUB6TEP74PYJOPWIR013S2AV29YUBW5F9ZH2F4D5UMJUJ6S@hash.domains";
    name = "Thomas Strobel";
  };
  ttuegel = {
    email = "ttuegel@mailbox.org";
    github = "ttuegel";
    name = "Thomas Tuegel";
  };
  tv = {
    email = "tv@krebsco.de";
    github = "4z3";
    name = "Tomislav Viljetić";
  };
  tvestelind = {
    email = "tomas.vestelind@fripost.org";
    github = "tvestelind";
    name = "Tomas Vestelind";
  };
  tvorog = {
    email = "marszaripov@gmail.com";
    github = "tvorog";
    name = "Marsel Zaripov";
  };
  tweber = {
    email = "tw+nixpkgs@360vier.de";
    github = "thorstenweber83";
    name = "Thorsten Weber";
  };
  twey = {
    email = "twey@twey.co.uk";
    github = "twey";
    name = "James ‘Twey’ Kay";
  };
  typetetris = {
    email = "ericwolf42@mail.com";
    github = "typetetris";
    name = "Eric Wolf";
  };
  udono = {
    email = "udono@virtual-things.biz";
    github = "udono";
    name = "Udo Spallek";
  };
  unode = {
    email = "alves.rjc@gmail.com";
    github = "unode";
    name = "Renato Alves";
  };
  uralbash = {
    email = "root@uralbash.ru";
    github = "uralbash";
    name = "Svintsov Dmitry";
  };
  uri-canva = {
    email = "uri@canva.com";
    github = "uri-canva";
    name = "Uri Baghin";
  };
  uskudnik = {
    email = "urban.skudnik@gmail.com";
    github = "uskudnik";
    name = "Urban Skudnik";
  };
  utdemir = {
    email = "me@utdemir.com";
    github = "utdemir";
    name = "Utku Demir";
  };
  uvnikita = {
    email = "uv.nikita@gmail.com";
    github = "uvNikita";
    name = "Nikita Uvarov";
  };
  uwap = {
    email = "me@uwap.name";
    github = "uwap";
    name = "uwap";
  };
  va1entin = {
    email = "github@valentinsblog.com";
    github = "va1entin";
    name = "Valentin Heidelberger";
  };
  vaibhavsagar = {
    email = "vaibhavsagar@gmail.com";
    github = "vaibhavsagar";
    name = "Vaibhav Sagar";
  };
  valeriangalliat = {
    email = "val@codejam.info";
    github = "valeriangalliat";
    name = "Valérian Galliat";
  };
  vandenoever = {
    email = "jos@vandenoever.info";
    github = "vandenoever";
    name = "Jos van den Oever";
  };
  vanschelven = {
    email = "klaas@vanschelven.com";
    github = "vanschelven";
    name = "Klaas van Schelven";
  };
  vanzef = {
    email = "vanzef@gmail.com";
    github = "vanzef";
    name = "Ivan Solyankin";
  };
  varunpatro = {
    email = "varun.kumar.patro@gmail.com";
    github = "varunpatro";
    name = "Varun Patro";
  };
  vbgl = {
    email = "Vincent.Laporte@gmail.com";
    github = "vbgl";
    name = "Vincent Laporte";
  };
  vbmithr = {
    email = "vb@luminar.eu.org";
    github = "vbmithr";
    name = "Vincent Bernardoff";
  };
  vcunat = {
    name = "Vladimír Čunát";
    email = "v@cunat.cz"; # vcunat@gmail.com predominated in commits before 2019/03
    github = "vcunat";
    keys = [{
      longkeyid = "rsa4096/0xE747DF1F9575A3AA";
      fingerprint = "B600 6460 B60A 80E7 8206  2449 E747 DF1F 9575 A3AA";
    }];
  };
  vdemeester = {
    email = "vincent@sbr.pm";
    github = "vdemeester";
    name = "Vincent Demeester";
  };
  velovix = {
    email = "xaviosx@gmail.com";
    github = "velovix";
    name = "Tyler Compton";
  };
  veprbl = {
    email = "veprbl@gmail.com";
    github = "veprbl";
    name = "Dmitry Kalinkin";
  };
  vidbina = {
    email = "vid@bina.me";
    github = "vidbina";
    name = "David Asabina";
  };
  vifino = {
    email = "vifino@tty.sh";
    github = "vifino";
    name = "Adrian Pistol";
  };
  vinymeuh = {
    email = "vinymeuh@gmail.com";
    github = "vinymeuh";
    name = "VinyMeuh";
  };
  viric = {
    email = "viric@viric.name";
    github = "viric";
    name = "Lluís Batlle i Rossell";
  };
  vizanto = {
    email = "danny@prime.vc";
    github = "vizanto";
    name = "Danny Wilson";
  };
  vklquevs = {
    email = "vklquevs@gmail.com";
    github = "vklquevs";
    name = "vklquevs";
  };
  vlaci = {
    email = "laszlo.vasko@outlook.com";
    github = "vlaci";
    name = "László Vaskó";
  };
  vlstill = {
    email = "xstill@fi.muni.cz";
    github = "vlstill";
    name = "Vladimír Štill";
  };
  vmandela = {
    email = "venkat.mandela@gmail.com";
    github = "vmandela";
    name = "Venkateswara Rao Mandela";
  };
  vmchale = {
    email = "tmchale@wisc.edu";
    github = "vmchale";
    name = "Vanessa McHale";
  };
  volhovm = {
    email = "volhovm.cs@gmail.com";
    github = "volhovm";
    name = "Mikhail Volkhov";
  };
  volth = {
    email = "jaroslavas@volth.com";
    github = "volth";
    name = "Jaroslavas Pocepko";
  };
  vozz = {
    email = "oliver.huntuk@gmail.com";
    name = "Oliver Hunt";
  };
  vrthra = {
    email = "rahul@gopinath.org";
    github = "vrthra";
    name = "Rahul Gopinath";
  };
  vskilet = {
    email = "victor@sene.ovh";
    github = "vskilet";
    name = "Victor SENE";
  };
  vyp = {
    email = "elisp.vim@gmail.com";
    github = "vyp";
    name = "vyp";
  };
  waynr = {
    name = "Wayne Warren";
    email = "wayne.warren.s@gmail.com";
    github = "waynr";
  };
  wchresta = {
    email = "wchresta.nix@chrummibei.ch";
    github = "wchresta";
    name = "wchresta";
  };
  wedens = {
    email = "kirill.wedens@gmail.com";
    name = "wedens";
  };
  willibutz = {
    email = "willibutz@posteo.de";
    github = "willibutz";
    name = "Willi Butz";
  };
  willtim = {
    email = "tim.williams.public@gmail.com";
    name = "Tim Philip Williams";
  };
  winden = {
    email = "windenntw@gmail.com";
    name = "Antonio Vargas Gonzalez";
  };
  winpat = {
    email = "patrickwinter@posteo.ch";
    github = "winpat";
    name = "Patrick Winter";
  };
  wizeman = {
    email = "rcorreia@wizy.org";
    github = "wizeman";
    name = "Ricardo M. Correia";
  };
  wjlroe = {
    email = "willroe@gmail.com";
    github = "wjlroe";
    name = "William Roe";
  };
  wmertens = {
    email = "Wout.Mertens@gmail.com";
    github = "wmertens";
    name = "Wout Mertens";
  };
  woffs = {
    email = "github@woffs.de";
    github = "woffs";
    name = "Frank Doepper";
  };
  womfoo = {
    email = "kranium@gikos.net";
    github = "womfoo";
    name = "Kranium Gikos Mendoza";
  };
  worldofpeace = {
    email = "worldofpeace@protonmail.ch";
    github = "worldofpeace";
    name = "Worldofpeace";
  };
  wscott = {
    email = "wsc9tt@gmail.com";
    github = "wscott";
    name = "Wayne Scott";
  };
  wucke13 = {
    email = "info@wucke13.de";
    github = "wucke13";
    name = "Wucke";
  };
  wykurz = {
    email = "wykurz@gmail.com";
    github = "wykurz";
    name = "Mateusz Wykurz";
  };
  wyvie = {
    email = "elijahrum@gmail.com";
    github = "wyvie";
    name = "Elijah Rum";
  };
  xaverdh = {
    email = "hoe.dom@gmx.de";
    github = "xaverdh";
    name = "Dominik Xaver Hörl";
  };
  xbreak = {
    email = "xbreak@alphaware.se";
    github = "xbreak";
    name = "Calle Rosenquist";
  };
  xeji = {
    email = "xeji@cat3.de";
    github = "xeji";
    name = "Uli Baum";
  };
  xnaveira = {
    email = "xnaveira@gmail.com";
    github = "xnaveira";
    name = "Xavier Naveira";
  };
  xnwdd = {
    email = "nwdd+nixos@no.team";
    github = "xnwdd";
    name = "Guillermo NWDD";
  };
  xrelkd = {
    email = "46590321+xrelkd@users.noreply.github.com";
    github = "xrelkd";
    name = "xrelkd";
  };
  xurei = {
    email = "olivier.bourdoux@gmail.com";
    github = "xurei";
    name = "Olivier Bourdoux";
  };
  xvapx = {
    email = "marti.serra.coscollano@gmail.com";
    github = "xvapx";
    name = "Marti Serra";
  };
  xwvvvvwx = {
    email = "davidterry@posteo.de";
    github = "xwvvvvwx";
    name = "David Terry";
  };
  xzfc = {
    email = "xzfcpw@gmail.com";
    github = "xzfc";
    name = "Albert Safin";
  };
  y0no = {
    email = "y0no@y0no.fr";
    github = "y0no";
    name = "Yoann Ono";
  };
  yarny = {
    email = "41838844+Yarny0@users.noreply.github.com";
    github = "Yarny0";
    name = "Yarny";
  };
  yarr = {
    email = "savraz@gmail.com";
    github = "Eternity-Yarr";
    name = "Dmitry V.";
  };
  yegortimoshenko = {
    email = "yegortimoshenko@riseup.net";
    github = "yegortimoshenko";
    name = "Yegor Timoshenko";
  };
  yesbox = {
    email = "jesper.geertsen.jonsson@gmail.com";
    github = "yesbox";
    name = "Jesper Geertsen Jonsson";
  };
  ylwghst = {
    email = "ylwghst@onionmail.info";
    github = "ylwghst";
    name = "Burim Augustin Berisa";
  };
  yochai = {
    email = "yochai@titat.info";
    github = "yochai";
    name = "Yochai";
  };
  yorickvp = {
    email = "yorickvanpelt@gmail.com";
    github = "yorickvp";
    name = "Yorick van Pelt";
  };
  yrashk = {
    email = "yrashk@gmail.com";
    github = "yrashk";
    name = "Yurii Rashkovskii";
  };
  ysndr = {
    email = "me@ysndr.de";
    github = "ysndr";
    name = "Yannik Sander";
  };
  yuriaisaka = {
    email = "yuri.aisaka+nix@gmail.com";
    github = "yuriaisaka";
    name = "Yuri Aisaka";
  };
  yurrriq = {
    email = "eric@ericb.me";
    github = "yurrriq";
    name = "Eric Bailey";
  };
  z77z = {
    email = "maggesi@math.unifi.it";
    github = "maggesi";
    name = "Marco Maggesi";
  };
  zachcoyle = {
    email = "zach.coyle@gmail.com";
    github = "zachcoyle";
    name = "Zach Coyle";
  };
  zagy = {
    email = "cz@flyingcircus.io";
    github = "zagy";
    name = "Christian Zagrodnick";
  };
  zalakain = {
    email = "contact@unaizalakain.info";
    github = "umazalakain";
    name = "Unai Zalakain";
  };
  zaninime = {
    email = "francesco@zanini.me";
    github = "zaninime";
    name = "Francesco Zanini";
  };
  zarelit = {
    email = "david@zarel.net";
    github = "zarelit";
    name = "David Costa";
  };
  zauberpony = {
    email = "elmar@athmer.org";
    github = "zauberpony";
    name = "Elmar Athmer";
  };
  zef = {
    email = "zef@zef.me";
    name = "Zef Hemel";
  };
  zgrannan = {
    email = "zgrannan@gmail.com";
    github = "zgrannan";
    name = "Zack Grannan";
  };
  zimbatm = {
    email = "zimbatm@zimbatm.com";
    github = "zimbatm";
    name = "zimbatm";
  };
  Zimmi48 = {
    email = "theo.zimmermann@univ-paris-diderot.fr";
    github = "Zimmi48";
    name = "Théo Zimmermann";
  };
  zohl = {
    email = "zohl@fmap.me";
    github = "zohl";
    name = "Al Zohali";
  };
  zookatron = {
    email = "tim@zookatron.com";
    github = "zookatron";
    name = "Tim Zook";
  };
  zoomulator = {
    email = "zoomulator@gmail.com";
    github = "zoomulator";
    name = "Kim Simmons";
  };
  zraexy = {
    email = "zraexy@gmail.com";
    github = "zraexy";
    name = "David Mell";
  };
  zx2c4 = {
    email = "Jason@zx2c4.com";
    github = "zx2c4";
    name = "Jason A. Donenfeld";
  };
  zzamboni = {
    email = "diego@zzamboni.org";
    github = "zzamboni";
    name = "Diego Zamboni";
  };
}
