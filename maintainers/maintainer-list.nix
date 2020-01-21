/* List of NixOS maintainers.

    handle = {
      # Required
      name = "Your name";
      email = "address@example.org";

      # Optional
      github = "GithubUsername";
      githubId = your-github-id;
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
  - `githubId` is your GitHub user ID, which can be found at `https://api.github.com/users/<userhandle>`,
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
  "00-matt" = {
    name = "Matt Smith";
    email = "matt@offtopica.uk";
    github = "00-matt";
    githubId = 48835712;
  };
  "0x4A6F" = {
    email = "0x4A6F@shackspace.de";
    name = "Joachim Ernst";
    github = "0x4A6F";
    githubId = 9675338;
    keys = [{
      longkeyid = "rsa8192/0x87027528B006D66D";
      fingerprint = "F466 A548 AD3F C1F1 8C88  4576 8702 7528 B006 D66D";
    }];
  };
  "1000101" = {
    email = "jan.hrnko@satoshilabs.com";
    github = "1000101";
    githubId = 791309;
    name = "Jan Hrnko";
  };
  a1russell = {
    email = "adamlr6+pub@gmail.com";
    github = "a1russell";
    githubId = 241628;
    name = "Adam Russell";
  };
  aanderse = {
    email = "aaron@fosslib.net";
    github = "aanderse";
    githubId = 7755101;
    name = "Aaron Andersen";
  };
  aaronjanse = {
    email = "aaron@ajanse.me";
    github = "aaronjanse";
    githubId = 16829510;
    name = "Aaron Janse";
  };
  aaronschif = {
    email = "aaronschif@gmail.com";
    github = "aaronschif";
    githubId = 2258953;
    name = "Aaron Schif";
  };
  abaldeau = {
    email = "andreas@baldeau.net";
    github = "baldo";
    githubId = 178750;
    name = "Andreas Baldeau";
  };
  abbe = {
    email = "ashish.is@lostca.se";
    github = "wahjava";
    githubId = 2255192;
    name = "Ashish SHUKLA";
    keys = [{
      longkeyid = "rsa4096/0xC746CFA9E74FA4B0";
      fingerprint = "F682 CDCC 39DC 0FEA E116  20B6 C746 CFA9 E74F A4B0";
    }];
  };
  abbradar = {
    email = "ab@fmap.me";
    github = "abbradar";
    name = "Nikolay Amiantov";
  };
  abhi18av = {
    email = "abhi18av@gmail.com";
    github = "abhi18av";
    githubId = 12799326;
    name = "Abhinav Sharma";
  };
  abigailbuccaneer = {
    email = "abigailbuccaneer@gmail.com";
    github = "abigailbuccaneer";
    githubId = 908758;
    name = "Abigail Bunyan";
  };
  aborsu = {
    email = "a.borsu@gmail.com";
    github = "aborsu";
    githubId = 5033617;
    name = "Augustin Borsu";
  };
  aboseley = {
    email = "adam.boseley@gmail.com";
    github = "aboseley";
    githubId = 13504599;
    name = "Adam Boseley";
  };
  abuibrahim = {
    email = "ruslan@babayev.com";
    github = "abuibrahim";
    githubId = 2321000;
    name = "Ruslan Babayev";
  };
  acairncross = {
    email = "acairncross@gmail.com";
    github = "acairncross";
    name = "Aiken Cairncross";
  };
  acowley = {
    email = "acowley@gmail.com";
    github = "acowley";
    githubId = 124545;
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
    githubId = 1332980;
    name = "Adelbert Chang";
  };
  adev = {
    email = "adev@adev.name";
    github = "adevress";
    githubId = 1773511;
    name = "Adrien Devresse";
  };
  adisbladis = {
    email = "adis@blad.is";
    github = "adisbladis";
    githubId = 63286;
    name = "Adam Hose";
  };
  Adjective-Object = {
    email = "mhuan13@gmail.com";
    github = "Adjective-Object";
    githubId = 1174858;
    name = "Maxwell Huang-Hobbs";
  };
  adnelson = {
    email = "ithinkican@gmail.com";
    github = "adnelson";
    githubId = 5091511;
    name = "Allen Nelson";
  };
  adolfogc = {
    email = "adolfo.garcia.cr@gmail.com";
    github = "adolfogc";
    githubId = 1250775;
    name = "Adolfo E. García Castro";
  };
  adsr = {
    email = "as@php.net";
    github = "adsr";
    githubId = 315003;
    name = "Adam Saponara";
  };
  aepsil0n = {
    email = "eduard.bopp@aepsil0n.de";
    github = "aepsil0n";
    githubId = 3098430;
    name = "Eduard Bopp";
  };
  aerialx = {
    email = "aaron+nixos@aaronlindsay.com";
    github = "AerialX";
    githubId = 117295;
    name = "Aaron Lindsay";
  };
  aespinosa = {
    email = "allan.espinosa@outlook.com";
    github = "aespinosa";
    githubId = 58771;
    name = "Allan Espinosa";
  };
  aethelz = {
    email = "aethelz@protonmail.com";
    github = "aethelz";
    githubId = 10677343;
    name = "Eugene";
  };
  aflatter = {
    email = "flatter@fastmail.fm";
    github = "aflatter";
    githubId = 168;
    name = "Alexander Flatter";
  };
  afldcr = {
    email = "alex@fldcr.com";
    github = "afldcr";
    githubId = 335271;
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
    githubId = 4296804;
    name = "Alex Franchuk";
  };
  aherrmann = {
    email = "andreash87@gmx.ch";
    github = "aherrmann";
    githubId = 732652;
    name = "Andreas Herrmann";
  };
  ahmedtd = {
    email = "ahmed.taahir@gmail.com";
    github = "ahmedtd";
    githubId = 1017202;
    name = "Taahir Ahmed";
  };
  ahuzik = {
    email = "ales.guzik@gmail.com";
    github = "alesguzik";
    githubId = 209175;
    name = "Ales Huzik";
  };
  aij = {
    email = "aij+git@mrph.org";
    github = "aij";
    githubId = 4732885;
    name = "Ivan Jager";
  };
  ajs124 = {
    email = "nix@ajs124.de";
    github = "ajs124";
    githubId = 1229027;
    name = "Andreas Schrägle";
  };
  ajgrf = {
    email = "a@ajgrf.com";
    github = "ajgrf";
    githubId = 10733175;
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
    githubId = 273837;
    name = "Mateusz Czapliński";
  };
  akaWolf = {
    email = "akawolf0@gmail.com";
    github = "akaWolf";
    githubId = 5836586;
    name = "Artjom Vejsel";
  };
  akc = {
    email = "akc@akc.is";
    github = "akc";
    githubId = 1318982;
    name = "Anders Claesson";
  };
  akru = {
    email = "mail@akru.me";
    github = "akru";
    githubId = 786394;
    name = "Alexander Krupenkin ";
  };
  alexarice = {
    email = "alexrice999@hotmail.co.uk";
    github = "alexarice";
    githubId = 17208985;
    name = "Alex Rice";
  };
  alexbakker = {
    email = "ab@alexbakker.me";
    github = "alexbakker";
    githubId = 2387841;
    name = "Alexander Bakker";
  };
  alexchapman = {
    email = "alex@farfromthere.net";
    github = "AJChapman";
    githubId = 8316672;
    name = "Alex Chapman";
  };
  alexfmpe = {
    email = "alexandre.fmp.esteves@gmail.com";
    github = "alexfmpe";
    githubId = 2335822;
    name = "Alexandre Esteves";
  };
  alexvorobiev = {
    email = "alexander.vorobiev@gmail.com";
    github = "alexvorobiev";
    githubId = 782180;
    name = "Alex Vorobiev";
  };
  algorith = {
    email = "dries_van_daele@telenet.be";
    name = "Dries Van Daele";
  };
  alibabzo = {
    email = "alistair.bill@gmail.com";
    github = "alibabzo";
    githubId = 2822871;
    name = "Alistair Bill";
  };
  alkeryn = {
    email = "plbraundev@gmail.com";
    github = "Alkeryn";
    githubId = 11599075;
    name = "Pierre-Louis Braun";
  };
  all = {
    email = "nix-commits@lists.science.uu.nl";
    name = "Nix Committers";
  };
  allonsy = {
    email = "linuxbash8@gmail.com";
    github = "allonsy";
    githubId = 5892756;
    name = "Alec Snyder";
  };
  alunduil = {
    email = "alunduil@gmail.com";
    github = "alunduil";
    name = "Alex Brandt";
  };
  alva = {
    email = "alva@skogen.is";
    github = "fjallarefur";
    githubId = 42881386;
    name = "Alva";
    keys = [{
      longkeyid = "ed25519/0xF53E323342F7A6D3";
      fingerprint = "B422 CFB1 C9EF 73F7 E1E2 698D F53E 3233 42F7 A6D3A";
    }];
  };
  amar1729 = {
    email = "amar.paul16@gmail.com";
    github = "amar1729";
    githubId = 15623522;
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
    githubId = 1358320;
    name = "Arie Middelkoop";
  };
  amiloradovsky = {
    email = "miloradovsky@gmail.com";
    github = "amiloradovsky";
    githubId = 20530052;
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
    githubId = 5149377;
    name = "Amine Chikhaoui";
  };
  amorsillo = {
    email = "andrew.morsillo@gmail.com";
    github = "AndrewMorsillo";
    githubId = 858965;
    name = "Andrew Morsillo";
  };
  andersk = {
    email = "andersk@mit.edu";
    github = "andersk";
    githubId = 26471;
    name = "Anders Kaseorg";
  };
  anderslundstedt = {
    email = "git@anderslundstedt.se";
    github = "anderslundstedt";
    githubId = 4514101;
    name = "Anders Lundstedt";
  };
  AndersonTorres = {
    email = "torres.anderson.85@protonmail.com";
    github = "AndersonTorres";
    githubId = 5954806;
    name = "Anderson Torres";
  };
  anderspapitto = {
    email = "anderspapitto@gmail.com";
    github = "anderspapitto";
    githubId = 1388690;
    name = "Anders Papitto";
  };
  andir = {
    email = "andreas@rammhold.de";
    github = "andir";
    githubId = 638836;
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
    githubId = 7112447;
    name = "Andre S. Ramos";
  };
  andrew-d = {
    email = "andrew@du.nham.ca";
    github = "andrew-d";
    githubId = 1079173;
    name = "Andrew Dunham";
  };
  andrewchambers = {
    email = "ac@acha.ninja";
    github = "andrewchambers";
    githubId = 962885;
    name = "Andrew Chambers";
  };
  andrewrk = {
    email = "superjoe30@gmail.com";
    github = "andrewrk";
    githubId = 106511;
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
    githubId = 2085567;
    name = "Aneesh Agrawal";
  };
  angristan = {
    email = "angristan@pm.me";
    github = "angristan";
    githubId = 11699655;
    name = "Stanislas Lange";
  };
  ankhers = {
    email = "me@ankhers.dev";
    github = "ankhers";
    githubId = 750786;
    name = "Justin Wood";
  };
  anmonteiro = {
    email = "anmonteiro@gmail.com";
    github = "anmonteiro";
    githubId = 661909;
    name = "Antonio Nuno Monteiro";
  };
  anpryl = {
    email = "anpryl@gmail.com";
    github = "anpryl";
    githubId = 5327697;
    name = "Anatolii Prylutskyi";
  };
  anton-dessiatov = {
    email = "anton.dessiatov@gmail.com";
    github = "anton-dessiatov";
    githubId = 2873280;
    name = "Anton Desyatov";
  };
  Anton-Latukha = {
    email = "anton.latuka+nixpkgs@gmail.com";
    github = "Anton-Latukha";
    githubId = 20933385;
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
    githubId = 4194320;
    name = "Anton Schirg";
  };
  apeschar = {
    email = "albert@peschar.net";
    github = "apeschar";
    githubId = 122977;
    name = "Albert Peschar";
  };
  apeyroux = {
    email = "alex@px.io";
    github = "apeyroux";
    githubId = 1078530;
    name = "Alexandre Peyroux";
  };
  ar1a = {
    email = "aria@ar1as.space";
    github = "ar1a";
    githubId = 8436007;
    name = "Aria Edmonds";
  };
  arcadio = {
    email = "arc@well.ox.ac.uk";
    github = "arcadio";
    githubId = 56009;
    name = "Arcadio Rubio García";
  };
  arcnmx = {
    email = "arcnmx@users.noreply.github.com";
    github = "arcnmx";
    githubId = 13426784;
    name = "arcnmx";
  };
  ardumont = {
    email = "eniotna.t@gmail.com";
    github = "ardumont";
    githubId = 718812;
    name = "Antoine R. Dumont";
  };
  arianvp = {
    email = "arian.vanputten@gmail.com";
    github = "arianvp";
    githubId = 628387;
    name = "Arian van Putten";
  };
  aristid = {
    email = "aristidb@gmail.com";
    github = "aristidb";
    githubId = 30712;
    name = "Aristid Breitkreuz";
  };
  ariutta = {
    email = "anders.riutta@gmail.com";
    github = "ariutta";
    githubId = 1296771;
    name = "Anders Riutta";
  };
  arobyn = {
    email = "shados@shados.net";
    github = "shados";
    githubId = 338268;
    name = "Alexei Robyn";
  };
  artemist = {
    email = "me@artem.ist";
    github = "artemist";
    githubId = 1226638;
    name = "Artemis Tosini";
    keys = [{
      longkeyid = "rsa4096/0x4FDC96F161E7BA8A";
      fingerprint = "3D2B B230 F9FA F0C5 1832  46DD 4FDC 96F1 61E7 BA8A";
    }];
  };
  arthur = {
    email = "me@arthur.li";
    github = "arthurl";
    githubId = 3965744;
    name = "Arthur Lee";
  };
  artuuge = {
    email = "artuuge@gmail.com";
    github = "artuuge";
    githubId = 10285250;
    name = "Artur E. Ruuge";
  };
  ashalkhakov = {
    email = "artyom.shalkhakov@gmail.com";
    github = "ashalkhakov";
    githubId = 1270502;
    name = "Artyom Shalkhakov";
  };
  ashgillman = {
    email = "gillmanash@gmail.com";
    github = "ashgillman";
    githubId = 816777;
    name = "Ashley Gillman";
  };
  ashkitten = {
    email = "ashlea@protonmail.com";
    github = "ashkitten";
    githubId = 9281956;
    name = "ash lea";
  };
  aske = {
    email = "aske@fmap.me";
    github = "aske";
    githubId = 869771;
    name = "Kirill Boltaev";
  };
  asppsa = {
    email = "asppsa@gmail.com";
    github = "asppsa";
    githubId = 453170;
    name = "Alastair Pharo";
  };
  astro = {
    email = "astro@spaceboyz.net";
    github = "astro";
    githubId = 12923;
    name = "Astro";
  };
  astsmtl = {
    email = "astsmtl@yandex.ru";
    github = "astsmtl";
    githubId = 2093941;
    name = "Alexander Tsamutali";
  };
  asymmetric = {
    email = "lorenzo@mailbox.org";
    github = "asymmetric";
    githubId = 101816;
    name = "Lorenzo Manacorda";
  };
  aszlig = {
    email = "aszlig@nix.build";
    github = "aszlig";
    githubId = 192147;
    name = "aszlig";
  };
  athas = {
    email = "athas@sigkill.dk";
    github = "athas";
    githubId = 55833;
    name = "Troels Henriksen";
  };
  atnnn = {
    email = "etienne@atnnn.com";
    github = "atnnn";
    githubId = 706854;
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
    githubId = 1217745;
    name = "Aldwin Vlasblom";
  };
  avery = {
    email = "averyl+nixos@protonmail.com";
    github = "AveryLychee";
    githubId = 9147625;
    name = "Avery Lychee";
  };
  averelld = {
    email = "averell+nixos@rxd4.com";
    github = "averelld";
    name = "averelld";
  };
  avitex = {
    email = "theavitex@gmail.com";
    github = "avitex";
    githubId = 5110816;
    name = "avitex";
    keys = [{
      longkeyid = "rsa4096/0x8B366C443CABE942";
      fingerprint = "271E 136C 178E 06FA EA4E  B854 8B36 6C44 3CAB E942";
    }];
  };
  avnik = {
    email = "avn@avnik.info";
    github = "avnik";
    githubId = 153538;
    name = "Alexander V. Nikolaev";
  };
  aw = {
    email = "aw-nixos@meterriblecrew.net";
    github = "herrwiese";
    githubId = 206242;
    name = "Andreas Wiese";
  };
  aycanirican = {
    email = "iricanaycan@gmail.com";
    github = "aycanirican";
    githubId = 135230;
    name = "Aycan iRiCAN";
  };
  b4dm4n = {
    email = "fabianm88@gmail.com";
    github = "B4dM4n";
    githubId = 448169;
    name = "Fabian Möller";
    keys = [{
      longkeyid = "rsa4096/0x754B5C0963C42C5";
      fingerprint = "6309 E212 29D4 DA30 AF24  BDED 754B 5C09 63C4 2C50";
    }];
  };
  babariviere = {
    email = "babathriviere@gmail.com";
    github = "babariviere";
    githubId = 12128029;
    name = "babariviere";
  };
  bachp = {
    email = "pascal.bach@nextrem.ch";
    github = "bachp";
    githubId = 333807;
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
    githubId = 18467667;
    name = "Alexander Bantyev";
  };
  bandresen = {
    email = "bandresen@gmail.com";
    github = "bandresen";
    githubId = 80325;
    name = "Benjamin Andresen";
  };
  baracoder = {
    email = "baracoder@googlemail.com";
    github = "baracoder";
    githubId = 127523;
    name = "Herman Fries";
  };
  barrucadu = {
    email = "mike@barrucadu.co.uk";
    github = "barrucadu";
    githubId = 75235;
    name = "Michael Walker";
  };
  basvandijk = {
    email = "v.dijk.bas@gmail.com";
    github = "basvandijk";
    githubId = 576355;
    name = "Bas van Dijk";
  };
  Baughn = {
    email = "sveina@gmail.com";
    github = "Baughn";
    githubId = 45811;
    name = "Svein Ove Aas";
  };
  bb010g = {
    email = "me@bb010g.com";
    github = "bb010g";
    githubId = 340132;
    name = "Brayden Banks";
  };
  bbarker = {
    email = "brandon.barker@gmail.com";
    github = "bbarker";
    githubId = 916366;
    name = "Brandon Elam Barker";
  };
  bbigras = {
    email = "bigras.bruno@gmail.com";
    github = "bbigras";
    githubId = 24027;
    name = "Bruno Bigras";
  };
  bcarrell = {
    email = "brandoncarrell@gmail.com";
    github = "bcarrell";
    githubId = 1015044;
    name = "Brandon Carrell";
  };
  bcdarwin = {
    email = "bcdarwin@gmail.com";
    github = "bcdarwin";
    githubId = 164148;
    name = "Ben Darwin";
  };
  bdesham = {
    email = "benjamin@esham.io";
    github = "bdesham";
    githubId = 354230;
    name = "Benjamin Esham";
  };
  bdimcheff = {
    email = "brandon@dimcheff.com";
    github = "bdimcheff";
    githubId = 14111;
    name = "Brandon Dimcheff";
  };
  bendlas = {
    email = "herwig@bendlas.net";
    github = "bendlas";
    githubId = 214787;
    name = "Herwig Hochleitner";
  };
  benley = {
    email = "benley@gmail.com";
    github = "benley";
    githubId = 1432730;
    name = "Benjamin Staffin";
  };
  bennofs = {
    email = "benno.fuenfstueck@gmail.com";
    github = "bennofs";
    githubId = 3192959;
    name = "Benno Fünfstück";
  };
  benpye = {
    email = "ben@curlybracket.co.uk";
    github = "benpye";
    githubId = 442623;
    name = "Ben Pye";
  };
  benwbooth = {
    email = "benwbooth@gmail.com";
    github = "benwbooth";
    githubId = 75972;
    name = "Ben Booth";
  };
  berce = {
    email = "bert.moens@gmail.com";
    github = "berce";
    githubId = 10439709;
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
    githubId = 251106;
    name = "Daniel Bergey";
  };
  betaboon = {
    email = "betaboon@0x80.ninja";
    github = "betaboon";
    githubId = 7346933;
    name = "betaboon";
  };
  bfortz = {
    email = "bernard.fortz@gmail.com";
    github = "bfortz";
    githubId = 16426882;
    name = "Bernard Fortz";
  };
  bgamari = {
    email = "ben@smart-cactus.org";
    github = "bgamari";
    githubId = 1010174;
    name = "Ben Gamari";
  };
  bhall = {
    email = "brendan.j.hall@bath.edu";
    github = "brendan-hall";
    githubId = 34919100;
    name = "Brendan Hall";
  };
  bhipple = {
    email = "bhipple@protonmail.com";
    github = "bhipple";
    githubId = 2071583;
    name = "Benjamin Hipple";
  };
  binarin = {
    email = "binarin@binarin.ru";
    github = "binarin";
    githubId = 185443;
    name = "Alexey Lebedeff";
  };
  bjg = {
    email = "bjg@gnu.org";
    name = "Brian Gough";
  };
  bjornfor = {
    email = "bjorn.forsman@gmail.com";
    github = "bjornfor";
    githubId = 133602;
    name = "Bjørn Forsman";
  };
  bkchr = {
    email = "nixos@kchr.de";
    github = "bkchr";
    githubId = 5718007;
    name = "Bastian Köcher";
  };
  blitz = {
    email = "js@alien8.de";
    github = "blitz";
    githubId = 37907;
    name = "Julian Stecklina";
  };
  bluescreen303 = {
    email = "mathijs@bluescreen303.nl";
    github = "bluescreen303";
    name = "Mathijs Kwik";
  };
  bobakker = {
    email = "bobakk3r@gmail.com";
    github = "bobakker";
    githubId = 10221570;
    name = "Bo Bakker";
  };
  bobvanderlinden = {
    email = "bobvanderlinden@gmail.com";
    github = "bobvanderlinden";
    githubId = 6375609;
    name = "Bob van der Linden";
  };
  bodil = {
    email = "nix@bodil.org";
    github = "bodil";
    githubId = 17880;
    name = "Bodil Stokke";
  };
  boj = {
    email = "brian@uncannyworks.com";
    github = "boj";
    githubId = 50839;
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
    githubId = 1743184;
    name = "Boris Babić";
  };
  bosu = {
    email = "boriss@gmail.com";
    github = "bosu";
    githubId = 3465841;
    name = "Boris Sukholitko";
  };
  bradediger = {
    email = "brad@bradediger.com";
    github = "bradediger";
    githubId = 4621;
    name = "Brad Ediger";
  };
  brainrape = {
    email = "martonboros@gmail.com";
    github = "brainrape";
    githubId = 302429;
    name = "Marton Boros";
  };
  bramd = {
    email = "bram@bramd.nl";
    github = "bramd";
    githubId = 86652;
    name = "Bram Duvigneau";
  };
  braydenjw = {
    email = "nixpkgs@willenborg.ca";
    github = "braydenjw";
    githubId = 2506621;
    name = "Brayden Willenborg";
  };
  brian-dawn = {
    email = "brian.t.dawn@gmail.com";
    github = "brian-dawn";
    githubId = 1274409;
    name = "Brian Dawn";
  };
  brianhicks = {
    email = "brian@brianthicks.com";
    github = "BrianHicks";
    githubId = 355401;
    name = "Brian Hicks";
  };
  bricewge = {
    email = "bricewge@gmail.com";
    github = "bricewge";
    githubId = 5525646;
    name = "Brice Waegeneire";
  };
  bstrik = {
    email = "dutchman55@gmx.com";
    github = "bstrik";
    githubId = 7716744;
    name = "Berno Strik";
  };
  buffet = {
    email = "niclas@countingsort.com";
    github = "buffet";
    githubId = 33751841;
    name = "Niclas Meyer";
  };
  bugworm = {
    email = "bugworm@zoho.com";
    github = "bugworm";
    githubId = 7214361;
    name = "Roman Gerasimenko";
  };
  bzizou = {
    email = "Bruno@bzizou.net";
    github = "bzizou";
    githubId = 2647566;
    name = "Bruno Bzeznik";
  };
  c0bw3b = {
    email = "c0bw3b@gmail.com";
    github = "c0bw3b";
    githubId = 24417923;
    name = "Renaud";
  };
  c0deaddict = {
    email = "josvanbakel@protonmail.com";
    github = "c0deaddict";
    githubId = 510553;
    name = "Jos van Bakel";
  };
  cab404 = {
    email = "cab404@mailbox.org";
    github = "cab404";
    githubId = 6453661;
    name = "Vladimir Serov";
    keys = [
      # compare with https://keybase.io/cab404
      { longkeyid = "1BB96810926F4E715DEF567E6BA7C26C3FDF7BB3";
        fingerprint = "rsa3072/0xCBDECF658C38079E";
      }
      { longkeyid = "1EBC648C64D6045463013B3EB7EFFC271D55DB8A";
        fingerprint = "ed25519/0xB7EFFC271D55DB8A";
      }
    ];
  };
  calbrecht = {
    email = "christian.albrecht@mayflower.de";
    github = "calbrecht";
    githubId = 1516457;
    name = "Christian Albrecht";
  };
  callahad = {
    email = "dan.callahan@gmail.com";
    github = "callahad";
    githubId = 24193;
    name = "Dan Callahan";
  };
  calvertvl = {
    email = "calvertvl@gmail.com";
    github = "calvertvl";
    githubId = 7435854;
    name = "Victor Calvert";
  };
  campadrenalin = {
    email = "campadrenalin@gmail.com";
    github = "campadrenalin";
    githubId = 289492;
    name = "Philip Horger";
  };
  candeira = {
    email = "javier@candeira.com";
    github = "candeira";
    githubId = 91694;
    name = "Javier Candeira";
  };
  canndrew = {
    email = "shum@canndrew.org";
    github = "canndrew";
    githubId = 5555066;
    name = "Andrew Cann";
  };
  cap = {
    name = "cap";
    email = "nixos_xasenw9@digitalpostkasten.de";
    github = "scaredmushroom";
    githubId = 45340040;
  };
  carlosdagos = {
    email = "m@cdagostino.io";
    github = "carlosdagos";
    githubId = 686190;
    name = "Carlos D'Agostino";
  };
  carlsverre = {
    email = "accounts@carlsverre.com";
    github = "carlsverre";
    githubId = 82591;
    name = "Carl Sverre";
  };
  cartr = {
    email = "carter.sande@duodecima.technology";
    github = "cartr";
    githubId = 5241813;
    name = "Carter Sande";
  };
  casey = {
    email = "casey@rodarmor.net";
    github = "casey";
    githubId = 1945;
    name = "Casey Rodarmor";
  };
  catern = {
    email = "sbaugh@catern.com";
    github = "catern";
    githubId = 5394722;
    name = "Spencer Baugh";
  };
  caugner = {
    email = "nixos@caugner.de";
    github = "caugner";
    githubId = 495429;
    name = "Claas Augner";
  };
  cbley = {
    email = "claudio.bley@gmail.com";
    github = "avdv";
    githubId = 3471749;
    name = "Claudio Bley";
  };
  cdepillabout = {
    email = "cdep.illabout@gmail.com";
    github = "cdepillabout";
    githubId = 64804;
    name = "Dennis Gosnell";
  };
  ceedubs = {
    email = "ceedubs@gmail.com";
    github = "ceedubs";
    githubId = 977929;
    name = "Cody Allen";
  };
  cfouche = {
    email = "chaddai.fouche@gmail.com";
    github = "Chaddai";
    githubId = 5771456;
    name = "Chaddaï Fouché";
  };
  cfsmp3 = {
    email = "carlos@sanz.dev";
    github = "cfsmp3";
    githubId = 5949913;
    name = "Carlos Fernandez Sanz";
  };
  chaduffy = {
    email = "charles@dyfis.net";
    github = "charles-dyfis-net";
    githubId = 22370;
    name = "Charles Duffy";
  };
  changlinli = {
    email = "mail@changlinli.com";
    github = "changlinli";
    githubId = 1762540;
    name = "Changlin Li";
  };
  CharlesHD = {
    email = "charleshdespointes@gmail.com";
    github = "CharlesHD";
    githubId = 6608071;
    name = "Charles Huyghues-Despointes";
  };
  chaoflow = {
    email = "flo@chaoflow.net";
    github = "chaoflow";
    githubId = 89596;
    name = "Florian Friesdorf";
  };
  chattered = {
    email = "me@philscotted.com";
    name = "Phil Scott";
  };
  ChengCat = {
    email = "yu@cheng.cat";
    github = "ChengCat";
    githubId = 33503784;
    name = "Yucheng Zhang";
  };
  chessai = {
    email = "chessai1996@gmail.com";
    github = "chessai";
    githubId = 18648043;
    name = "Daniel Cartwright";
  };
  chiiruno = {
    email = "okinan@protonmail.com";
    github = "chiiruno";
    githubId = 30435868;
    name = "Okina Matara";
  };
  chkno = {
    email = "chuck@intelligence.org";
    github = "chkno";
    githubId = 1118859;
    name = "Scott Worley";
  };
  choochootrain = {
    email = "hurshal@imap.cc";
    github = "choochootrain";
    githubId = 803961;
    name = "Hurshal Patel";
  };
  chpatrick = {
    email = "chpatrick@gmail.com";
    github = "chpatrick";
    githubId = 832719;
    name = "Patrick Chilton";
  };
  chreekat = {
    email = "b@chreekat.net";
    github = "chreekat";
    githubId = 538538;
    name = "Bryan Richter";
  };
  chris-martin = {
    email = "ch.martin@gmail.com";
    github = "chris-martin";
    githubId = 399718;
    name = "Chris Martin";
  };
  chrisaw = {
    email = "home@chrisaw.com";
    github = "cawilliamson";
    githubId = 1141769;
    name = "Christopher A. Williamson";
  };
  chrisjefferson = {
    email = "chris@bubblescope.net";
    github = "chrisjefferson";
    githubId = 811527;
    name = "Christopher Jefferson";
  };
  chrisrosset = {
    email = "chris@rosset.org.uk";
    github = "chrisrosset";
    githubId = 1103294;
    name = "Christopher Rosset";
  };
  christopherpoole = {
    email = "mail@christopherpoole.net";
    github = "christopherpoole";
    githubId = 2245737;
    name = "Christopher Mark Poole";
  };
  ciil = {
    email = "simon@lackerbauer.com";
    github = "ciil";
    githubId = 3956062;
    name = "Simon Lackerbauer";
  };
  cizra = {
    email = "todurov+nix@gmail.com";
    github = "cizra";
    githubId = 2131991;
    name = "Elmo Todurov";
  };
  ck3d = {
    email = "ck3d@gmx.de";
    github = "ck3d";
    githubId = 25088352;
    name = "Christian Kögler";
  };
  kampka = {
    email = "christian@kampka.net";
    github = "kampka";
    githubId = 422412;
    name = "Christian Kampka";
    keys = [{
      longkeyid = "ed25519/0x1CBE9645DD68E915";
      fingerprint = "F7FA 0BD0 8775 337C F6AB  4A14 1CBE 9645 DD68 E915";
    }];
  };
  ckauhaus = {
    email = "kc@flyingcircus.io";
    github = "ckauhaus";
    githubId = 1448923;
    name = "Christian Kauhaus";
  };
  cko = {
    email = "christine.koppelt@gmail.com";
    github = "cko";
    githubId = 68239;
    name = "Christine Koppelt";
  };
  clacke = {
    email = "claes.wallin@greatsinodevelopment.com";
    github = "clacke";
    githubId = 199180;
    name = "Claes Wallin";
  };
  cleverca22 = {
    email = "cleverca22@gmail.com";
    github = "cleverca22";
    githubId = 848609;
    name = "Michael Bishop";
  };
  cmcdragonkai = {
    email = "roger.qiu@matrix.ai";
    github = "cmcdragonkai";
    githubId = 640797;
    name = "Roger Qiu";
  };
  cmfwyp = {
    email = "cmfwyp@riseup.net";
    github = "cmfwyp";
    githubId = 20808761;
    name = "cmfwyp";
  };
  cobbal = {
    email = "andrew.cobb@gmail.com";
    github = "cobbal";
    githubId = 180339;
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
    githubId = 6402559;
    name = "codsl";
  };
  codyopel = {
    email = "codyopel@gmail.com";
    github = "codyopel";
    githubId = 5561189;
    name = "Cody Opel";
  };
  cohencyril = {
    email = "cyril.cohen@inria.fr";
    github = "CohenCyril";
    githubId = 298705;
    name = "Cyril Cohen";
  };
  colemickens = {
    email = "cole.mickens@gmail.com";
    github = "colemickens";
    githubId = 327028;
    name = "Cole Mickens";
  };
  colescott = {
    email = "colescottsf@gmail.com";
    github = "colescott";
    githubId = 5684605;
    name = "Cole Scott";
  };
  copumpkin = {
    email = "pumpkingod@gmail.com";
    github = "copumpkin";
    githubId = 2623;
    name = "Dan Peebles";
  };
  corngood = {
    email = "corngood@gmail.com";
    github = "corngood";
    githubId = 3077118;
    name = "David McFarland";
  };
  coroa = {
    email = "jonas@chaoflow.net";
    github = "coroa";
    githubId = 2552981;
    name = "Jonas Hörsch";
  };
  costrouc = {
    email = "chris.ostrouchov@gmail.com";
    github = "costrouc";
    githubId = 1740337;
    name = "Chris Ostrouchov";
  };
  contrun = {
    email = "uuuuuu@protonmail.com";
    github = "contrun";
    githubId = 32609395;
    name = "B YI";
  };
  couchemar = {
    email = "couchemar@yandex.ru";
    github = "couchemar";
    githubId = 1573344;
    name = "Andrey Pavlov";
  };
  cpages = {
    email = "page@ruiec.cat";
    github = "cpages";
    githubId = 411324;
    name = "Carles Pagès";
  };
  craigem = {
    email = "craige@mcwhirter.io";
    github = "craigem";
    githubId = 6470493;
    name = "Craige McWhirter";
  };
  cransom = {
    email = "cransom@hubns.net";
    github = "cransom";
    name = "Casey Ransom";
  };
  CrazedProgrammer = {
    email = "crazedprogrammer@gmail.com";
    github = "CrazedProgrammer";
    githubId = 12202789;
    name = "CrazedProgrammer";
  };
  cryptix = {
    email = "cryptix@riseup.net";
    github = "cryptix";
    githubId = 111202;
    name = "Henry Bubert";
  };
  CrystalGamma = {
    email = "nixos@crystalgamma.de";
    github = "CrystalGamma";
    githubId = 6297001;
    name = "Jona Stubbe";
  };
  csingley = {
    email = "csingley@gmail.com";
    github = "csingley";
    githubId = 398996;
    name = "Christopher Singley";
  };
  cstrahan = {
    email = "charles@cstrahan.com";
    github = "cstrahan";
    githubId = 143982;
    name = "Charles Strahan";
  };
  cswank = {
    email = "craigswank@gmail.com";
    github = "cswank";
    githubId = 490965;
    name = "Craig Swank";
  };
  cwoac = {
    email = "oliver@codersoffortune.net";
    github = "cwoac";
    githubId = 1382175;
    name = "Oliver Matthews";
  };
  cypherpunk2140 = {
    email = "stefan.mihaila@pm.me";
    github = "stefan-mihaila";
    githubId = 2217136;
    name = "Ștefan D. Mihăilă";
    keys = [
      { longkeyid = "rsa4096/6E68A39BF16A3ECB";
        fingerprint = "CBC9 C7CC 51F0 4A61 3901 C723 6E68 A39B F16A 3ECB";
      }
      { longkeyid = "rsa4096/6220AD7846220A52";
        fingerprint = "7EAB 1447 5BBA 7DDE 7092 7276 6220 AD78 4622 0A52";
      }
    ];
  };
  d-goldin = {
    email = "dgoldin+github@protonmail.ch";
    github = "d-goldin";
    githubId = 43349662;
    name = "Dima";
    keys = [{
      longkeyid = "rsa4096/BAB1D15FB7B4D4CE";
      fingerprint = "1C4E F4FE 7F8E D8B7 1E88 CCDF BAB1 D15F B7B4 D4CE";
    }];
  };
  dadada = {
    name = "dadada";
    email = "dadada@dadada.li";
    github = "dadada";
    githubId = 7216772;
    keys = [{
      longkeyid = "ed25519/0xEEB8D1CE62C4DFEA";
      fingerprint = "D68C 8469 5C08 7E0F 733A  28D0 EEB8 D1CE 62C4 DFEA";
    }];
  };
  dalance = {
    email = "dalance@gmail.com";
    github = "dalance";
    githubId = 4331004;
    name = "Naoya Hatta";
  };
  DamienCassou = {
    email = "damien@cassou.me";
    github = "DamienCassou";
    githubId = 217543;
    name = "Damien Cassou";
  };
  danbst = {
    email = "abcz2.uprola@gmail.com";
    github = "danbst";
    githubId = 743057;
    name = "Danylo Hlynskyi";
  };
  dancek = {
    email = "hannu.hartikainen@gmail.com";
    github = "dancek";
    githubId = 245394;
    name = "Hannu Hartikainen";
  };
  danderson = {
    email = "dave@natulte.net";
    github = "danderson";
    githubId = 1918;
    name = "David Anderson";
  };
  danharaj = {
    email = "dan@obsidian.systems";
    github = "danharaj";
    githubId = 23366017;
    name = "Dan Haraj";
  };
  danieldk = {
    email = "me@danieldk.eu";
    github = "danieldk";
    githubId = 49398;
    name = "Daniël de Kok";
  };
  danielfullmer = {
    email = "danielrf12@gmail.com";
    github = "danielfullmer";
    githubId = 1298344;
    name = "Daniel Fullmer";
  };
  das-g = {
    email = "nixpkgs@raphael.dasgupta.ch";
    github = "das-g";
    githubId = 97746;
    name = "Raphael Das Gupta";
  };
  das_j = {
    email = "janne@hess.ooo";
    github = "dasJ";
    githubId = 4971975;
    name = "Janne Heß";
  };
  dasuxullebt = {
    email = "christoph.senjak@googlemail.com";
    name = "Christoph-Simon Senjak";
  };
  david50407 = {
    email = "me@davy.tw";
    github = "david50407";
    githubId = 841969;
    name = "David Kuo";
  };
  davidak = {
    email = "post@davidak.de";
    github = "davidak";
    githubId = 91113;
    name = "David Kleuker";
  };
  davidrusu = {
    email = "davidrusu.me@gmail.com";
    github = "davidrusu";
    name = "David Rusu";
  };
  davidtwco = {
    email = "nix@david.davidtw.co";
    github = "davidtwco";
    githubId = 1295100;
    name = "David Wood";
    keys = [{
      longkeyid = "rsa4096/0x01760B4F9F53F154";
      fingerprint = "5B08 313C 6853 E5BF FA91  A817 0176 0B4F 9F53 F154";
    }];
  };
  davorb = {
    email = "davor@davor.se";
    github = "davorb";
    githubId = 798427;
    name = "Davor Babic";
  };
  dawidsowa = {
    email = "dawid_sowa@posteo.net";
    github = "dawidsowa";
    githubId = 49904992;
    name = "Dawid Sowa";
  };
  dbohdan = {
    email = "dbohdan@dbohdan.com";
    github = "dbohdan";
    githubId = 3179832;
    name = "D. Bohdan";
  };
  dbrock = {
    email = "daniel@brockman.se";
    github = "dbrock";
    githubId = 14032;
    name = "Daniel Brockman";
  };
  dduan = {
    email = "daniel@duan.ca";
    github = "dduan";
    githubId = 75067;
    name = "Daniel Duan";
  };
  deepfire = {
    email = "_deepfire@feelingofgreen.ru";
    github = "deepfire";
    githubId = 452652;
    name = "Kosyrev Serge";
  };
  delan = {
    name = "Delan Azabani";
    email = "delan@azabani.com";
    github = "delan";
    githubId = 465303;
  };
  delroth = {
    email = "delroth@gmail.com";
    github = "delroth";
    githubId = 202798;
    name = "Pierre Bourdon";
  };
  deltaevo = {
    email = "deltaduartedavid@gmail.com";
    github = "DeltaEvo";
    githubId = 8864716;
    name = "Duarte David";
  };
  demin-dmitriy = {
    email = "demindf@gmail.com";
    github = "demin-dmitriy";
    githubId = 5503422;
    name = "Dmitriy Demin";
  };
  demize = {
    email = "johannes@kyriasis.com";
    github = "kyrias";
    githubId = 2285387;
    name = "Johannes Löthberg";
  };
  demyanrogozhin = {
    email = "demyan.rogozhin@gmail.com";
    github = "demyanrogozhin";
    githubId = 62989;
    name = "Demyan Rogozhin";
  };
  derchris = {
    email = "derchris@me.com";
    github = "derchrisuk";
    githubId = 706758;
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
    githubId = 4956158;
    name = "Robin Stumm";
  };
  DerTim1 = {
    email = "tim.digel@active-group.de";
    github = "DerTim1";
    githubId = 21953890;
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
    githubId = 896182;
    name = "devhell";
  };
  dezgeg = {
    email = "tuomas.tynkkynen@iki.fi";
    github = "dezgeg";
    githubId = 579369;
    name = "Tuomas Tynkkynen";
  };
  dfordivam = {
    email = "dfordivam+nixpkgs@gmail.com";
    github = "dfordivam";
    githubId = 681060;
    name = "Divam";
  };
  dfoxfranke = {
    email = "dfoxfranke@gmail.com";
    github = "dfoxfranke";
    githubId = 4708206;
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
    githubId = 265220;
    name = "David Leung";
  };
  dipinhora = {
    email = "dipinhora+github@gmail.com";
    github = "dipinhora";
    githubId = 11946442;
    name = "Dipin Hora";
  };
  dirkx = {
    email = "dirkx@webweaving.org";
    github = "dirkx";
    githubId = 392583;
    name = "Dirk-Willem van Gulik";
  };
  disassembler = {
    email = "disasm@gmail.com";
    github = "disassembler";
    githubId = 651205;
    name = "Samuel Leathers";
  };
  disserman = {
    email = "disserman@gmail.com";
    github = "divi255";
    githubId = 40633781;
    name = "Sergei S.";
  };
  dizfer = {
    email = "david@izquierdofernandez.com";
    github = "dizfer";
    githubId = 8852888;
    name = "David Izquierdo";
  };
  Dje4321 = {
    email = "dje4321@gmail.com";
    github = "dje4321";
    githubId = 10913120;
    name = "Dje4321";
  };
  dkabot = {
    email = "dkabot@dkabot.com";
    github = "dkabot";
    githubId = 1316469;
    name = "Naomi Morse";
  };
  dkudriavtsev = {
    email = "dkudriavtsev@gmail.com";
    github = "dkudriavtsev";
    githubId = 9790772;
    name = "Dmitry Kudriavtsev";
  };
  dmalikov = {
    email = "malikov.d.y@gmail.com";
    github = "dmalikov";
    githubId = 997543;
    name = "Dmitry Malikov";
  };
  DmitryTsygankov = {
    email = "dmitry.tsygankov@gmail.com";
    github = "DmitryTsygankov";
    githubId = 425354;
    name = "Dmitry Tsygankov";
  };
  dmjio = {
    email = "djohnson.m@gmail.com";
    github = "dmjio";
    githubId = 875324;
    name = "David Johnson";
  };
  dmrauh = {
    email = "dmrauh@posteo.de";
    github = "dmrauh";
    githubId = 37698547;
    name = "Dominik Michael Rauh";
  };
  dmvianna = {
    email = "dmlvianna@gmail.com";
    github = "dmvianna";
    githubId = 1708810;
    name = "Daniel Vianna";
  };
  dochang = {
    email = "dochang@gmail.com";
    github = "dochang";
    githubId = 129093;
    name = "Desmond O. Chang";
  };
  domenkozar = {
    email = "domen@dev.si";
    github = "domenkozar";
    githubId = 126339;
    name = "Domen Kozar";
  };
  doronbehar = {
    email = "me@doronbehar.com";
    github = "doronbehar";
    githubId = 10998835;
    name = "Doron Behar";
  };
  dotlambda = {
    email = "rschuetz17@gmail.com";
    github = "dotlambda";
    githubId = 6806011;
    name = "Robert Schütz";
  };
  doublec = {
    email = "chris.double@double.co.nz";
    github = "doublec";
    name = "Chris Double";
  };
  dpaetzel = {
    email = "david.paetzel@posteo.de";
    github = "dpaetzel";
    githubId = 974130;
    name = "David Pätzel";
  };
  dpflug = {
    email = "david@pflug.email";
    github = "dpflug";
    githubId = 108501;
    name = "David Pflug";
  };
  drets = {
    email = "dmitryrets@gmail.com";
    github = "drets";
    githubId = 6199462;
    name = "Dmytro Rets";
  };
  drewkett = {
    email = "burkett.andrew@gmail.com";
    name = "Andrew Burkett";
  };
  dsferruzza = {
    email = "david.sferruzza@gmail.com";
    github = "dsferruzza";
    githubId = 1931963;
    name = "David Sferruzza";
  };
  dtzWill = {
    email = "w@wdtz.org";
    github = "dtzWill";
    githubId = 817330;
    name = "Will Dietz";
    keys = [{
      longkeyid = "rsa4096/0xFD42C7D0D41494C8";
      fingerprint = "389A 78CB CD88 5E0C 4701  DEB9 FD42 C7D0 D414 94C8";
    }];
  };
  dump_stack = {
    email = "root@dumpstack.io";
    github = "jollheef";
    githubId = 1749762;
    name = "Mikhail Klementev";
    keys = [{
      longkeyid = "rsa4096/0x1525585D1B43C62A";
      fingerprint = "5DD7 C6F6 0630 F08E DAE7  4711 1525 585D 1B43 C62A";
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
    githubId = 447;
    name = "Tim Dysinger";
  };
  dywedir = {
    email = "dywedir@gra.red";
    github = "dywedir";
    githubId = 399312;
    name = "Vladyslav M.";
  };
  dzabraev = {
    email = "dzabraew@gmail.com";
    github = "dzabraev";
    githubId = 15128988;
    name = "Maksim Dzabraev";
  };
  e-user = {
    email = "nixos@sodosopa.io";
    github = "e-user";
    githubId = 93086;
    name = "Alexander Kahl";
  };
  eadwu = {
    email = "edmund.wu@protonmail.com";
    github = "eadwu";
    githubId = 22758444;
    name = "Edmund Wu";
  };
  ealasu = {
    email = "emanuel.alasu@gmail.com";
    github = "ealasu";
    githubId = 1362096;
    name = "Emanuel Alasu";
  };
  eamsden = {
    email = "edward@blackriversoft.com";
    github = "eamsden";
    githubId = 54573;
    name = "Edward Amsden";
  };
  earldouglas = {
    email = "james@earldouglas.com";
    github = "earldouglas";
    githubId = 424946;
    name = "James Earl Douglas";
  };
  earvstedt = {
    email = "erik.arvstedt@gmail.com";
    github = "erikarvstedt";
    githubId = 36110478;
    name = "Erik Arvstedt";
  };
  ebzzry = {
    email = "ebzzry@ebzzry.io";
    github = "ebzzry";
    githubId = 7875;
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
    githubId = 50854;
    name = "edef";
  };
  emantor = {
    email = "rouven+nixos@czerwinskis.de";
    github = "emantor";
    githubId = 934284;
    name = "Rouven Czerwinski";
  };
  embr = {
    email = "hi@liclac.eu";
    github = "liclac";
    githubId = 428026;
    name = "embr";
  };
  emily = {
    email = "nixpkgs@emily.moe";
    github = "emilazy";
    githubId = 18535642;
    name = "Emily";
  };
  endocrimes = {
    email = "dani@builds.terrible.systems";
    github = "endocrimes";
    githubId = 1330683;
    name = "Danielle Lancashire";
  };
  ederoyd46 = {
    email = "matt@ederoyd.co.uk";
    github = "ederoyd46";
    githubId = 119483;
    name = "Matthew Brown";
  };
  eduarrrd = {
    email = "e.bachmakov@gmail.com";
    github = "eduarrrd";
    githubId = 1181393;
    name = "Eduard Bachmakov";
  };
  edude03 = {
    email = "michael@melenion.com";
    github = "edude03";
    githubId = 494483;
    name = "Michael Francis";
  };
  edwtjo = {
    email = "ed@cflags.cc";
    github = "edwtjo";
    githubId = 54799;
    name = "Edward Tjörnhammar";
  };
  eelco = {
    email = "edolstra+nixpkgs@gmail.com";
    github = "edolstra";
    githubId = 1148549;
    name = "Eelco Dolstra";
  };
  ehegnes = {
    email = "eric.hegnes@gmail.com";
    github = "ehegnes";
    githubId = 884970;
    name = "Eric Hegnes";
  };
  ehmry = {
    email = "ehmry@posteo.net";
    github= "ehmry";
    githubId = 537775;
    name = "Emery Hemingway";
  };
  eikek = {
    email = "eike.kettner@posteo.de";
    github = "eikek";
    githubId = 701128;
    name = "Eike Kettner";
  };
  ekleog = {
    email = "leo@gaspard.io";
    github = "ekleog";
    githubId = 411447;
    name = "Leo Gaspard";
  };
  elasticdog = {
    email = "aaron@elasticdog.com";
    github = "elasticdog";
    githubId = 4742;
    name = "Aaron Bull Schaefer";
  };
  eleanor = {
    email = "dejan@proteansec.com";
    github = "proteansec";
    githubId = 1753498;
    name = "Dejan Lukan";
  };
  eliasp = {
    email = "mail@eliasprobst.eu";
    github = "eliasp";
    githubId = 48491;
    name = "Elias Probst";
  };
  elijahcaine = {
    email = "elijahcainemv@gmail.com";
    github = "pop";
    githubId = 1897147;
    name = "Elijah Caine";
  };
  elitak = {
    email = "elitak@gmail.com";
    github = "elitak";
    githubId = 769073;
    name = "Eric Litak";
  };
  ellis = {
    email = "nixos@ellisw.net";
    github = "ellis";
    githubId = 97852;
    name = "Ellis Whitehead";
  };
  elohmeier = {
    email = "elo-nixos@nerdworks.de";
    github = "elohmeier";
    githubId = 2536303;
    name = "Enno Lohmeier";
  };
  elseym = {
    email = "elseym@me.com";
    github = "elseym";
    githubId = 907478;
    name = "Simon Waibl";
  };
  elvishjerricco = {
    email = "elvishjerricco@gmail.com";
    github = "ElvishJerricco";
    githubId = 1365692;
    name = "Will Fancher";
  };
  elyhaka = {
    email = "elyhaka@protonmail.com";
    github = "Elyhaka";
    githubId = 57923898;
    name = "Elyhaka";
  };
  emmanuelrosa = {
    email = "emmanuel_rosa@aol.com";
    github = "emmanuelrosa";
    name = "Emmanuel Rosa";
  };
  endgame = {
    email = "jack@jackkelly.name";
    github = "endgame";
    githubId = 231483;
    name = "Jack Kelly";
  };
  enorris = {
      name = "Eric Norris";
      email = "erictnorris@gmail.com";
      github = "ericnorris";
      githubId = 1906605;
  };
  Enteee = {
    email = "nix@duckpond.ch";
    github = "Enteee";
    githubid = 5493775;
    name = "Ente";
  };
  enzime = {
    email = "enzime@users.noreply.github.com";
    github = "enzime";
    githubId = 10492681;
    name = "Michael Hoang";
  };
  eonpatapon = {
    email = "eon@patapon.info";
    github = "eonpatapon";
    githubId = 418227;
    name = "Jean-Philippe Braun";
  };
  eperuffo = {
    email = "info@emanueleperuffo.com";
    github = "emanueleperuffo";
    githubId = 5085029;
    name = "Emanuele Peruffo";
  };
  epitrochoid = {
    email = "mpcervin@uncg.edu";
    name = "Mabry Cervin";
  };
  equirosa = {
    email = "eduardo@eduardoquiros.com";
    github = "equirosa";
    githubId = 39096810;
    name = "Eduardo Quiros";
  };
  eqyiel = {
    email = "ruben@maher.fyi";
    github = "eqyiel";
    githubId = 3422442;
    name = "Ruben Maher";
  };
  eraserhd = {
    email = "jason.m.felice@gmail.com";
    github = "eraserhd";
    githubId = 147284;
    name = "Jason Felice";
  };
  ericbmerritt = {
    email = "eric@afiniate.com";
    github = "ericbmerritt";
    githubId = 4828;
    name = "Eric Merritt";
  };
  ericdallo = {
    email = "ercdll1337@gmail.com";
    github = "ericdallo";
    name = "Eric Dallo";
  };
  ericsagnes = {
    email = "eric.sagnes@gmail.com";
    github = "ericsagnes";
    name = "Eric Sagnes";
  };
  ericson2314 = {
    email = "John.Ericson@Obsidian.Systems";
    github = "ericson2314";
    githubId = 1055245;
    name = "John Ericson";
  };
  erictapen = {
    email = "justin.humm@posteo.de";
    github = "erictapen";
    githubId = 11532355;
    name = "Justin Humm";
    keys = [{
      longkeyid = "rsa4096/0x438871E000AA178E";
      fingerprint = "984E 4BAD 9127 4D0E AE47  FF03 4388 71E0 00AA 178E";
    }];
  };
  erikryb = {
    email = "erik.rybakken@math.ntnu.no";
    github = "erikryb";
    githubId = 3787281;
    name = "Erik Rybakken";
  };
  erosennin = {
    email = "ag@sologoc.com";
    github = "erosennin";
    githubId = 1583484;
    name = "Andrey Golovizin";
  };
  ersin = {
    email = "me@ersinakinci.com";
    github = "earksiinni";
    githubId = 5427394;
    name = "Ersin Akinci";
  };
  ertes = {
    email = "esz@posteo.de";
    github = "ertes";
    name = "Ertugrul Söylemez";
  };
  esclear = {
    email = "esclear@users.noreply.github.com";
    github = "esclear";
    githubId = 7432848;
    name = "Daniel Albert";
  };
  Esteth = {
    email = "adam.copp@gmail.com";
    name = "Adam Copp";
  };
  ethercrow = {
    email = "ethercrow@gmail.com";
    github = "ethercrow";
    githubId = 222467;
    name = "Dmitry Ivanov";
  };
  etu = {
    email = "elis@hirwing.se";
    github = "etu";
    githubId = 461970;
    name = "Elis Hirwing";
    keys = [{
      longkeyid = "rsa4096/0xD57EFA625C9A925F";
      fingerprint = "67FE 98F2 8C44 CF22 1828  E12F D57E FA62 5C9A 925F";
    }];
  };
  evanjs = {
    email = "evanjsx@gmail.com";
    github = "evanjs";
    githubId = 1847524;
    name = "Evan Stoll";
  };
  evck = {
    email = "eric@evenchick.com";
    github = "ericevenchick";
    githubId = 195032;
    name = "Eric Evenchick";
  };
  evenbrenden = {
    email = "evenbrenden@gmail.com";
    github = "evenbrenden";
    githubId = 2512008;
    name = "Even Brenden";
  };
  evils = {
    email = "evils.devils@protonmail.com";
    github = "evils-devils";
    githubId = 30512529;
    name = "Evils";
  };
  exfalso = {
    email = "0slemi0@gmail.com";
    github = "exfalso";
    githubId = 1042674;
    name = "Andras Slemmer";
  };
  exi = {
    email = "nixos@reckling.org";
    github = "exi";
    githubId = 449463;
    name = "Reno Reckling";
  };
  exlevan = {
    email = "exlevan@gmail.com";
    github = "exlevan";
    githubId = 873530;
    name = "Alexey Levan";
  };
  expipiplus1 = {
    email = "nix@monoid.al";
    github = "expipiplus1";
    githubId = 857308;
    name = "Joe Hermaszewski";
  };
  eyjhb = {
    email = "eyjhbb@gmail.com";
    github = "eyJhb";
    githubId = 25955146;
    name = "eyJhb";
  };
  f--t = {
    email = "git@f-t.me";
    github = "f--t";
    githubId = 2817965;
    name = "f--t";
  };
  fadenb = {
    email = "tristan.helmich+nixos@gmail.com";
    github = "fadenb";
    githubId = 878822;
    name = "Tristan Helmich";
  };
  falsifian = {
    email = "james.cook@utoronto.ca";
    github = "falsifian";
    githubId = 225893;
    name = "James Cook";
  };
  fare = {
    email = "fahree@gmail.com";
    github = "fare";
    name = "Francois-Rene Rideau";
  };
  farlion = {
    email = "florian.peter@gmx.at";
    github = "workflow";
    githubId = 1276854;
    name = "Florian Peter";
  };
  fdns = {
    email = "fdns02@gmail.com";
    github = "fdns";
    name = "Felipe Espinoza";
  };
  ffinkdevs = {
    email = "fink@h0st.space";
    github = "ffinkdevs";
    githubId = 45924649;
    name = "Fabian Fink";
  };
  fgaz = {
    email = "fgaz@fgaz.me";
    github = "fgaz";
    githubId = 8182846;
    name = "Francesco Gazzetta";
  };
  filalex77 = {
    email = "brightone@protonmail.com";
    github = "filalex77";
    githubId = 12615679;
    name = "Oleksii Filonenko";
    keys = [{
      longkeyid = "rsa3072/0xA1BC8428323ECFE8";
      fingerprint = "F549 3B7F 9372 5578 FDD3  D0B8 A1BC 8428 323E CFE8";
    }];
  };
  FireyFly = {
    email = "nix@firefly.nu";
    github = "FireyFly";
    githubId = 415760;
    name = "Jonas Höglund";
  };
  Flakebi = {
    email = "flakebi@t-online.de";
    github = "Flakebi";
    githubId = 6499211;
    name = "Sebastian Neubauer";
    keys = [{
      longkeyid = "rsa4096/0xECC755EE583C1672";
      fingerprint = "2F93 661D AC17 EA98 A104  F780 ECC7 55EE 583C 1672";
    }];
  };
  flexw = {
    email = "felix.weilbach@t-online.de";
    github = "FlexW";
    githubId = 19961516;
    name = "Felix Weilbach";
  };
  flokli = {
    email = "flokli@flokli.de";
    github = "flokli";
    githubId = 183879;
    name = "Florian Klink";
  };
  FlorianFranzen = {
    email = "Florian.Franzen@gmail.com";
    github = "FlorianFranzen";
    githubId = 781077;
    name = "Florian Franzen";
  };
  florianjacob = {
    email = "projects+nixos@florianjacob.de";
    github = "florianjacob";
    githubId = 1109959;
    name = "Florian Jacob";
  };
  flosse = {
    email = "mail@markus-kohlhase.de";
    github = "flosse";
    githubId = 276043;
    name = "Markus Kohlhase";
  };
  fluffynukeit = {
    email = "dan@fluffynukeit.com";
    github = "fluffynukeit";
    githubId = 844574;
    name = "Daniel Austin";
  };
  flyfloh = {
    email = "nix@halbmastwurf.de";
    github = "flyfloh";
    githubId = 74379;
    name = "Florian Pester";
  };
  fmthoma = {
    email = "f.m.thoma@googlemail.com";
    github = "fmthoma";
    githubId = 5918766;
    name = "Franz Thoma";
  };
  forkk = {
    email = "forkk@forkk.net";
    github = "forkk";
    githubId = 1300078;
    name = "Andrew Okin";
  };
  fornever = {
    email = "friedrich@fornever.me";
    github = "fornever";
    githubId = 92793;
    name = "Friedrich von Never";
  };
  fpletz = {
    email = "fpletz@fnordicwalking.de";
    github = "fpletz";
    githubId = 114159;
    name = "Franz Pletz";
    keys = [{
      longkeyid = "rsa4096/0x846FDED7792617B4";
      fingerprint = "8A39 615D CE78 AF08 2E23  F303 846F DED7 7926 17B4";
    }];
  };
  fps = {
    email = "mista.tapas@gmx.net";
    github = "fps";
    githubId = 84968;
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
    githubId = 7551358;
    name = "Frede Emil";
  };
  freepotion = {
    email = "42352817+freepotion@users.noreply.github.com";
    github = "freepotion";
    githubId = 42352817;
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
    githubId = 2129135;
    name = "Frederik Rietdijk";
  };
  frlan = {
    email = "frank@frank.uvena.de";
    github = "frlan";
    githubId = 1010248;
    name = "Frank Lanitz";
  };
  fro_ozen = {
    email = "fro_ozen@gmx.de";
    github = "froozen";
    githubId = 1943632;
    name = "fro_ozen";
  };
  frontsideair = {
    email = "photonia@gmail.com";
    github = "frontsideair";
    githubId = 868283;
    name = "Fatih Altinok";
  };
  ftrvxmtrx = {
    email = "ftrvxmtrx@gmail.com";
    github = "ftrvxmtrx";
    githubId = 248148;
    name = "Siarhei Zirukin";
  };
  fuerbringer = {
    email = "severin@fuerbringer.info";
    github = "fuerbringer";
    githubId = 10528737;
    name = "Severin Fürbringer";
  };
  funfunctor = {
    email = "eocallaghan@alterapraxis.com";
    name = "Edward O'Callaghan";
  };
  fusion809 = {
    email = "brentonhorne77@gmail.com";
    github = "fusion809";
    githubId = 4717341;
    name = "Brenton Horne";
  };
  fuuzetsu = {
    email = "fuuzetsu@fuuzetsu.co.uk";
    github = "fuuzetsu";
    githubId = 893115;
    name = "Mateusz Kowalczyk";
  };
  fuwa = {
    email = "echowss@gmail.com";
    github = "fuwa0529";
    githubId = 40521440;
    name = "Haruka Akiyama";
  };
  fuzen = {
    email = "me@fuzen.cafe";
    github = "fuzen-py";
    githubId = 17859309;
    name = "Fuzen";
  };
  fuzzy-id = {
    email = "hacking+nixos@babibo.de";
    name = "Thomas Bach";
  };
  fxfactorial = {
    email = "edgar.factorial@gmail.com";
    github = "fxfactorial";
    githubId = 3036816;
    name = "Edgar Aroutiounian";
  };
  gabesoft = {
    email = "gabesoft@gmail.com";
    github = "gabesoft";
    githubId = 606000;
    name = "Gabriel Adomnicai";
  };
  gal_bolle = {
    email = "florent.becker@ens-lyon.org";
    github = "FlorentBecker";
    githubId = 7047019;
    name = "Florent Becker";
  };
  gamb = {
    email = "adam.gamble@pm.me";
    github = "gamb";
    githubId = 293586;
    name = "Adam Gamble";
  };
  garbas = {
    email = "rok@garbas.si";
    github = "garbas";
    name = "Rok Garbas";
  };
  garrison = {
    email = "jim@garrison.cc";
    github = "garrison";
    githubId = 91987;
    name = "Jim Garrison";
  };
  gavin = {
    email = "gavin.rogers@holo.host";
    github = "gavinrogers";
    name = "Gavin Rogers";
  };
  gazally = {
    email = "gazally@runbox.com";
    github = "gazally";
    githubId = 16470252;
    name = "Gemini Lasswell";
  };
  gebner = {
    email = "gebner@gebner.org";
    github = "gebner";
    githubId = 313929;
    name = "Gabriel Ebner";
  };
  geistesk = {
    email = "post@0x21.biz";
    github = "geistesk";
    githubId = 8402811;
    name = "Alvar Penning";
  };
  genesis = {
    email = "ronan@aimao.org";
    github = "bignaux";
    githubId = 149484;
    name = "Ronan Bignaux";
  };
  georgewhewell = {
    email = "georgerw@gmail.com";
    github = "georgewhewell";
    githubId = 1176131;
    name = "George Whewell";
  };
  gerschtli = {
    email = "tobias.happ@gmx.de";
    github = "Gerschtli";
    githubId = 10353047;
    name = "Tobias Happ";
  };
  ggpeti = {
    email = "ggpeti@gmail.com";
    github = "ggpeti";
    githubId = 3217744;
    name = "Peter Ferenczy";
  };
  gilligan = {
    email = "tobias.pflug@gmail.com";
    github = "gilligan";
    githubId = 27668;
    name = "Tobias Pflug";
  };
  giogadi = {
    email = "lgtorres42@gmail.com";
    github = "giogadi";
    githubId = 1713676;
    name = "Luis G. Torres";
  };
  gleber = {
    email = "gleber.p@gmail.com";
    github = "gleber";
    githubId = 33185;
    name = "Gleb Peregud";
  };
  glenns = {
    email = "glenn.searby@gmail.com";
    github = "glenns";
    githubId = 615606;
    name = "Glenn Searby";
  };
  gloaming = {
    email = "ch9871@gmail.com";
    github = "gloaming";
    githubId = 10156748;
    name = "Craig Hall";
  };
  globin = {
    email = "mail@glob.in";
    github = "globin";
    githubId = 1447245;
    name = "Robin Gloster";
  };
  gnidorah = {
    email = "gnidorah@yandex.com";
    github = "gnidorah";
    githubId = 12064730;
    name = "Alex Ivanov";
  };
  goibhniu = {
    email = "cillian.deroiste@gmail.com";
    github = "cillianderoiste";
    githubId = 643494;
    name = "Cillian de Róiste";
  };
  Gonzih = {
    email = "gonzih@gmail.com";
    github = "Gonzih";
    githubId = 266275;
    name = "Max Gonzih";
  };
  goodrone = {
    email = "goodrone@gmail.com";
    github = "goodrone";
    githubId = 1621335;
    name = "Andrew Trachenko";
  };
  gpyh = {
    email = "yacine.hmito@gmail.com";
    github = "yacinehmito";
    githubId = 6893840;
    name = "Yacine Hmito";
  };
  grahamc = {
    email = "graham@grahamc.com";
    github = "grahamc";
    githubId = 76716;
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
    githubId = 7385287;
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
    githubId = 1178864;
    name = "David Guibert";
  };
  groodt = {
    email = "groodt@gmail.com";
    github = "groodt";
    githubId = 343415;
    name = "Greg Roodt";
  };
  guibou = {
    email = "guillaum.bouchard@gmail.com";
    github = "guibou";
    githubId = 9705357;
    name = "Guillaume Bouchard";
  };
  GuillaumeDesforges = {
    email = "aceus02@gmail.com";
    github = "GuillaumeDesforges";
    githubId = 1882000;
    name = "Guillaume Desforges";
  };
  guillaumekoenig = {
    email = "guillaume.edward.koenig@gmail.com";
    github = "guillaumekoenig";
    githubId = 10654650;
    name = "Guillaume Koenig";
  };
  guyonvarch = {
    email = "joris@guyonvarch.me";
    github = "guyonvarch";
    githubId = 6768842;
    name = "Joris Guyonvarch";
  };
  hakuch = {
    email = "hakuch@gmail.com";
    github = "hakuch";
    githubId = 1498782;
    name = "Jesse Haber-Kucharsky";
  };
  hamhut1066 = {
    email = "github@hamhut1066.com";
    github = "moredhel";
    githubId = 1742172;
    name = "Hamish Hutchings";
  };
  hansjoergschurr = {
    email = "commits@schurr.at";
    github = "hansjoergschurr";
    githubId = 9850776;
    name = "Hans-Jörg Schurr";
    };
  HaoZeke = {
    email = "r95g10@gmail.com";
    github = "haozeke";
    githubId = 4336207;
    name = "Rohit Goswami";
  };
  haslersn = {
    email = "haslersn@fius.informatik.uni-stuttgart.de";
    github = "haslersn";
    githubId = 33969028;
    name = "Sebastian Hasler";
  };
  havvy = {
    email = "ryan.havvy@gmail.com";
    github = "havvy";
    githubId = 731722;
    name = "Ryan Scheel";
  };
  hax404 = {
    email = "hax404foogit@hax404.de";
    github = "hax404";
    githubId = 1379411;
    name = "Georg Haas";
  };
  hbunke = {
    email = "bunke.hendrik@gmail.com";
    github = "hbunke";
    githubId = 1768793;
    name = "Hendrik Bunke";
  };
  hce = {
    email = "hc@hcesperer.org";
    github = "hce";
    githubId = 147689;
    name = "Hans-Christian Esperer";
  };
  hectorj = {
    email = "hector.jusforgues+nixos@gmail.com";
    github = "hectorj";
    githubId = 2427959;
    name = "Hector Jusforgues";
  };
  hedning = {
    email = "torhedinbronner@gmail.com";
    github = "hedning";
    githubId = 71978;
    name = "Tor Hedin Brønner";
  };
  heel = {
    email = "parizhskiy@gmail.com";
    github = "heel";
    githubId = 287769;
    name = "Sergii Paryzhskyi";
  };
  helkafen = {
    email = "arnaudpourseb@gmail.com";
    github = "Helkafen";
    githubId = 2405974;
    name = "Sébastian Méric de Bellefon";
  };
  henrytill = {
    email = "henrytill@gmail.com";
    github = "henrytill";
    githubId = 6430643;
    name = "Henry Till";
  };
  herberteuler = {
    email = "herberteuler@gmail.com";
    github = "herberteuler";
    githubId = 1401179;
    name = "Guanpeng Xu";
  };
  hexa = {
    github = "mweinelt";
    githubId = 131599;
    name = "Martin Weinelt";
  };
  hhm = {
    email = "heehooman+nixpkgs@gmail.com";
    github = "hhm0";
    githubId = 3656888;
    name = "hhm";
  };
  hinton = {
    email = "t@larkery.com";
    name = "Tom Hinton";
  };
  hkjn = {
    email = "me@hkjn.me";
    name = "Henrik Jonsson";
    github = "hkjn";
    keys = [{
      longkeyid = "rsa4096/0x03EFBF839A5FDC15";
      fingerprint = "D618 7A03 A40A 3D56 62F5  4B46 03EF BF83 9A5F DC15";
    }];
  };
  hlolli = {
    email = "hlolli@gmail.com";
    github = "hlolli";
    githubId = 6074754;
    name = "Hlodver Sigurdsson";
  };
  hugoreeves = {
    email = "hugolreeves@gmail.com";
    github = "hugoreeves";
    githubId = 20039091;
    name = "Hugo Reeves";
  };
  hodapp = {
    email = "hodapp87@gmail.com";
    github = "Hodapp87";
    githubId = 896431;
    name = "Chris Hodapp";
  };
  hrdinka = {
    email = "c.nix@hrdinka.at";
    github = "hrdinka";
    githubId = 1436960;
    name = "Christoph Hrdinka";
  };
  hschaeidt = {
    email = "he.schaeidt@gmail.com";
    github = "hschaeidt";
    githubId = 1614615;
    name = "Hendrik Schaeidt";
  };
  htr = {
    email = "hugo@linux.com";
    github = "htr";
    githubId = 39689;
    name = "Hugo Tavares Reis";
  };
  hyphon81 = {
    email = "zero812n@gmail.com";
    github = "hyphon81";
    githubId = 12491746;
    name = "Masato Yonekawa";
  };
  iand675 = {
    email = "ian@iankduncan.com";
    github = "iand675";
    githubId = 69209;
    name = "Ian Duncan";
  };
  ianmjones = {
    email = "ian@ianmjones.com";
    github = "ianmjones";
    githubId = 4710;
    name = "Ian M. Jones";
  };
  ianwookim = {
    email = "ianwookim@gmail.com";
    github = "wavewave";
    githubId = 1031119;
    name = "Ian-Woo Kim";
  };
  iblech = {
    email = "iblech@speicherleck.de";
    github = "iblech";
    githubId = 3661115;
    name = "Ingo Blechschmidt";
  };
  idontgetoutmuch = {
    email = "dominic@steinitz.org";
    github = "idontgetoutmuch";
    githubId = 1550265;
    name = "Dominic Steinitz";
  };
  igsha = {
    email = "igor.sharonov@gmail.com";
    github = "igsha";
    githubId = 5345170;
    name = "Igor Sharonov";
  };
  iimog = {
    email = "iimog@iimog.org";
    github = "iimog";
    githubId = 7403236;
    name = "Markus J. Ankenbrand";
  };
  ikervagyok = {
    email = "ikervagyok@gmail.com";
    github = "ikervagyok";
    githubId = 7481521;
    name = "Balázs Lengyel";
  };
  ilikeavocadoes = {
    email = "ilikeavocadoes@hush.com";
    github = "ilikeavocadoes";
    githubId = 36193715;
    name = "Lassi Haasio";
  };
  illegalprime = {
    email = "themichaeleden@gmail.com";
    github = "illegalprime";
    githubId = 4401220;
    name = "Michael Eden";
  };
  ilya-kolpakov = {
    email = "ilya.kolpakov@gmail.com";
    github = "ilya-kolpakov";
    githubId = 592849;
    name = "Ilya Kolpakov";
  };
  imalison = {
    email = "IvanMalison@gmail.com";
    github = "IvanMalison";
    githubId = 1246619;
    name = "Ivan Malison";
  };
  imalsogreg = {
    email = "imalsogreg@gmail.com";
    github = "imalsogreg";
    githubId = 993484;
    name = "Greg Hale";
  };
  imuli = {
    email = "i@imu.li";
    github = "imuli";
    githubId = 4085046;
    name = "Imuli";
  };
  infinisil = {
    email = "contact@infinisil.com";
    github = "infinisil";
    githubId = 20525370;
    name = "Silvan Mosberger";
    keys = [{
      longkeyid = "rsa4096/0x422E9EDAE0157170";
      fingerprint = "6C2B 55D4 4E04 8266 6B7D  DA1A 422E 9EDA E015 7170";
    }];
  };
  ingenieroariel = {
    email = "ariel@nunez.co";
    github = "ingenieroariel";
    githubId = 54999;
    name = "Ariel Nunez";
  };
  ironpinguin = {
    email = "michele@catalano.de";
    github = "ironpinguin";
    githubId = 137306;
    name = "Michele Catalano";
  };
  isgy = {
    email = "isgy@teiyg.com";
    github = "isgy";
    githubId = 13622947;
    keys = [{
      longkeyid = "rsa4096/0xD3E1B013B4631293";
      fingerprint = "1412 816B A9FA F62F D051 1975 D3E1 B013 B463 1293";
    }];
  };
  ivan = {
    email = "ivan@ludios.org";
    github = "ivan";
    githubId = 4458;
    name = "Ivan Kozik";
  };
  ivan-tkatchev = {
    email = "tkatchev@gmail.com";
    name = "Ivan Tkatchev";
  };
  ivanbrennan = {
    email = "ivan.brennan@gmail.com";
    github = "ivanbrennan";
    githubId = 1672874;
    name = "Ivan Brennan";
    keys = [{
      longkeyid = "rsa4096/0x79C3C47DC652EA54";
      fingerprint = "7311 2700 AB4F 4CDF C68C  F6A5 79C3 C47D C652 EA54";
    }];
  };
  ivegotasthma = {
    email = "ivegotasthma@protonmail.com";
    github = "ivegotasthma";
    githubId = 2437675;
    name = "John Doe";
    keys = [{
      longkeyid = "rsa4096/09AC52AEA87817A4";
      fingerprint = "4008 2A5B 56A4 79B9 83CB  95FD 09AC 52AE A878 17A4";
    }];
  };
  ixmatus = {
    email = "parnell@digitalmentat.com";
    github = "ixmatus";
    githubId = 30714;
    name = "Parnell Springmeyer";
  };
  ixxie = {
    email = "matan@fluxcraft.net";
    github = "ixxie";
    githubId = 20320695;
    name = "Matan Bendix Shenhav";
  };
  izorkin = {
    email = "Izorkin@gmail.com";
    github = "izorkin";
    githubId = 26877687;
    name = "Yurii Izorkin";
  };
  jacg = {
    name = "Jacek Generowicz";
    email = "jacg@my-post-office.net";
    github = "jacg";
    githubId = 2570854;
  };
  jasoncarr = {
    email = "jcarr250@gmail.com";
    github = "jasoncarr0";
    name = "Jason Carr";
  };
  j-keck = {
    email = "jhyphenkeck@gmail.com";
    github = "j-keck";
    githubId = 3081095;
    name = "Jürgen Keck";
  };
  j03 = {
    email = "github@johannesloetzsch.de";
    github = "johannesloetzsch";
    name = "Johannes Lötzsch";
  };
  jagajaga = {
    email = "ars.seroka@gmail.com";
    github = "jagajaga";
    githubId = 2179419;
    name = "Arseniy Seroka";
  };
  jakelogemann = {
    email = "jake.logemann@gmail.com";
    github = "jakelogemann";
    githubId = 820715;
    name = "Jake Logemann";
  };
  jakestanger = {
    email = "mail@jstanger.dev";
    github = "JakeStanger";
    githubId = 5057870;
    name = "Jake Stanger";
  };
  jakewaksbaum = {
    email = "jake.waksbaum@gmail.com";
    github = "jbaum98";
    githubId = 5283991;
    name = "Jake Waksbaum";
  };
  jammerful = {
    email = "jammerful@gmail.com";
    github = "jammerful";
    githubId = 20176306;
    name = "jammerful";
  };
  jansol = {
    email = "jan.solanti@paivola.fi";
    github = "jansol";
    githubId = 2588851;
    name = "Jan Solanti";
  };
  javaguirre = {
    email = "contacto@javaguirre.net";
    github = "javaguirre";
    githubId = 488556;
    name = "Javier Aguirre";
  };
  jb55 = {
    email = "jb55@jb55.com";
    github = "jb55";
    githubId = 45598;
    name = "William Casarin";
  };
  jbedo = {
    email = "cu@cua0.org";
    github = "jbedo";
    githubId = 372912;
    name = "Justin Bedő";
  };
  jbgi = {
    email = "jb@giraudeau.info";
    github = "jbgi";
    githubId = 221929;
    name = "Jean-Baptiste Giraudeau";
  };
  jchw = {
    email = "johnwchadwick@gmail.com";
    github = "jchv";
    githubId = 938744;
    name = "John Chadwick";
  };
  jcumming = {
    email = "jack@mudshark.org";
    name = "Jack Cummings";
  };
  jD91mZM2 = {
    email = "me@krake.one";
    github = "jD91mZM2";
    githubId = 12830969;
    name = "jD91mZM2";
  };
  jdagilliland = {
    email = "jdagilliland@gmail.com";
    github = "jdagilliland";
    githubId = 1383440;
    name = "Jason Gilliland";
  };
  jdanek = {
    email = "jdanek@redhat.com";
    github = "jdanekrh";
    githubId = 17877663;
    keys = [{
      longkeyid = "ed25519/0x69275CADF15D872E";
      fingerprint = "D4A6 F051 AD58 2E7C BCED  5439 6927 5CAD F15D 872E";
    }];
    name = "Jiri Daněk";
  };
  jdehaas = {
    email = "qqlq@nullptr.club";
    github = "jeroendehaas";
    githubId = 117874;
    name = "Jeroen de Haas";
  };
  jefdaj = {
    email = "jefdaj@gmail.com";
    github = "jefdaj";
    githubId = 1198065;
    name = "Jeffrey David Johnson";
  };
  jensbin = {
    email = "jensbin+git@pm.me";
    github = "jensbin";
    githubId = 1608697;
    name = "Jens Binkert";
  };
  jerith666 = {
    email = "github@matt.mchenryfamily.org";
    github = "jerith666";
    githubId = 854319;
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
    githubId = 1667473;
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
    githubId = 18501;
    name = "Julien Langlois";
  };
  jfrankenau = {
    email = "johannes@frankenau.net";
    github = "jfrankenau";
    githubId = 2736480;
    name = "Johannes Frankenau";
  };
  jgeerds = {
    email = "jascha@geerds.org";
    github = "jgeerds";
    githubId = 1473909;
    name = "Jascha Geerds";
  };
  jgertm = {
    email = "jger.tm@gmail.com";
    github = "jgertm";
    githubId = 6616642;
    name = "Tim Jaeger";
  };
  jgillich = {
    email = "jakob@gillich.me";
    github = "jgillich";
    githubId = 347965;
    name = "Jakob Gillich";
  };
  jglukasik = {
    email = "joseph@jgl.me";
    github = "jglukasik";
    githubId = 6445082;
    name = "Joseph Lukasik";
  };
  jhhuh = {
    email = "jhhuh.note@gmail.com";
    github = "jhhuh";
    githubId = 5843245;
    name = "Ji-Haeng Huh";
  };
  jhillyerd = {
    email = "james+nixos@hillyerd.com";
    github = "jhillyerd";
    githubId = 2502736;
    name = "James Hillyerd";
  };
  jirkamarsik = {
    email = "jiri.marsik89@gmail.com";
    github = "jirkamarsik";
    githubId = 184898;
    name = "Jirka Marsik";
  };
  jitwit = {
    email = "jrn@bluefarm.ca";
    github = "jitwit";
    name = "jitwit";
  };
  jlesquembre = {
    email = "jl@lafuente.me";
    github = "jlesquembre";
    githubId = 1058504;
    name = "José Luis Lafuente";
  };
  jluttine = {
    email = "jaakko.luttinen@iki.fi";
    github = "jluttine";
    githubId = 2195834;
    name = "Jaakko Luttinen";
  };
  jm2dev = {
    email = "jomarcar@gmail.com";
    github = "jm2dev";
    githubId = 474643;
    name = "José Miguel Martínez Carrasco";
  };
  jmagnusj = {
    email = "jmagnusj@gmail.com";
    github = "magnusjonsson";
    githubId = 8900;
    name = "Johan Magnus Jonsson";
  };
  jmettes = {
    email = "jonathan@jmettes.com";
    github = "jmettes";
    githubId = 587870;
    name = "Jonathan Mettes";
  };
  joachifm = {
    email = "joachifm@fastmail.fm";
    github = "joachifm";
    githubId = 41977;
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
    githubId = 310981;
    name = "Joel Burget";
  };
  joelmo = {
    email = "joel.moberg@gmail.com";
    github = "joelmo";
    githubId = 336631;
    name = "Joel Moberg";
  };
  joelteon = {
    email = "me@joelt.io";
    name = "Joel Taylor";
  };
  joepie91 = {
    email = "admin@cryto.net";
    name = "Sven Slootweg";
    github = "joepie91";
  };
  joesalisbury = {
    email = "salisbury.joseph@gmail.com";
    github = "JosephSalisbury";
    githubId = 297653;
    name = "Joe Salisbury";
  };
  johanot = {
    email = "write@ownrisk.dk";
    github = "johanot";
    githubId = 998763;
    name = "Johan Thomsen";
  };
  johbo = {
    email = "johannes@bornhold.name";
    github = "johbo";
    githubId = 117805;
    name = "Johannes Bornhold";
  };
  johnazoidberg = {
    email = "git@danielschaefer.me";
    github = "johnazoidberg";
    githubId = 5307138;
    name = "Daniel Schäfer";
  };
  johnchildren = {
    email = "john.a.children@gmail.com";
    github = "johnchildren";
    githubId = 32305209;
    name = "John Children";
  };
  johnmh = {
    email = "johnmh@openblox.org";
    github = "johnmh";
    githubId = 2576152;
    name = "John M. Harris, Jr.";
  };
  johnramsden = {
    email = "johnramsden@riseup.net";
    github = "johnramsden";
    githubId = 8735102;
    name = "John Ramsden";
  };
  jojosch = {
    name = "Johannes Schleifenbaum";
    email = "johannes@js-webcoding.de";
    github = "jojosch";
    githubId = 327488;
    keys = [{
      longkeyid = "ed25519/059093B1A278BCD0";
      fingerprint = "7249 70E6 A661 D84E 8B47  678A 0590 93B1 A278 BCD0";
    }];
  };
  joko = {
    email = "ioannis.koutras@gmail.com";
    github = "jokogr";
    githubId = 1252547;
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
    githubId = 392720;
    name = "Jon Banafato";
  };
  jonathanmarler = {
    email = "johnnymarler@gmail.com";
    github = "marler8997";
    name = "Jonathan Marler";
  };
  jonathanreeve = {
    email = "jon.reeve@gmail.com";
    github = "JonathanReeve";
    githubId = 1843676;
    name = "Jonathan Reeve";
  };
  joncojonathan = {
    email = "joncojonathan@gmail.com";
    github = "joncojonathan";
    githubId = 11414454;
    name = "Jonathan Haddock";
  };
  jonringer = {
    email = "jonringer117@gmail.com";
    github = "jonringer";
    githubId = 7673602;
    name = "Jonathan Ringer";
  };
  jorise = {
    email = "info@jorisengbers.nl";
    github = "JorisE";
    githubId = 1767283;
    name = "Joris Engbers";
  };
  jorsn = {
    name = "Johannes Rosenberger";
    email = "johannes@jorsn.eu";
    github = "jorsn";
    githubId = 4646725;
  };
  jpdoyle = {
    email = "joethedoyle@gmail.com";
    github = "jpdoyle";
    githubId = 1918771;
    name = "Joe Doyle";
  };
  jpierre03 = {
    email = "nix@prunetwork.fr";
    github = "jpierre03";
    githubId = 954536;
    name = "Jean-Pierre PRUNARET";
  };
  jpotier = {
    email = "jpo.contributes.to.nixos@marvid.fr";
    github = "jpotier";
    githubId = 752510;
    name = "Martin Potier";
  };
  jqueiroz = {
    email = "nixos@johnjq.com";
    github = "jqueiroz";
    githubId = 4968215;
    name = "Jonathan Queiroz";
  };
  jraygauthier = {
    email = "jraygauthier@gmail.com";
    github = "jraygauthier";
    githubId = 4611077;
    name = "Raymond Gauthier";
  };
  jtcoolen = {
    email = "jtcoolen@pm.me";
    name = "Julien Coolen";
    github = "jtcoolen";
    githubId = 54635632;
    keys = [{
      longkeyid = "rsa4096/0x19642151C218F6F5";
      fingerprint = "4C68 56EE DFDA 20FB 77E8  9169 1964 2151 C218 F6F5";
    }];
  };
  jtobin = {
    email = "jared@jtobin.io";
    github = "jtobin";
    githubId = 1414434;
    name = "Jared Tobin";
  };
  jtojnar = {
    email = "jtojnar@gmail.com";
    github = "jtojnar";
    githubId = 705123;
    name = "Jan Tojnar";
  };
  juaningan = {
    email = "juaningan@gmail.com";
    github = "juaningan";
    githubId = 810075;
    name = "Juan Rodal";
  };
  juliendehos = {
    email = "dehos@lisic.univ-littoral.fr";
    github = "juliendehos";
    name = "Julien Dehos";
  };
  jumper149 = {
    email = "felixspringer149@gmail.com";
    github = "jumper149";
    githubId = 39434424;
    name = "Felix Springer";
  };
  justinwoo = {
    email = "moomoowoo@gmail.com";
    github = "justinwoo";
    githubId = 2396926;
    name = "Justin Woo";
  };
  jwiegley = {
    email = "johnw@newartisans.com";
    github = "jwiegley";
    githubId = 8460;
    name = "John Wiegley";
  };
  jwijenbergh = {
    email = "jeroenwijenbergh@protonmail.com";
    github = "jwijenbergh";
    githubId = 46386452;
    name = "Jeroen Wijenbergh";
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
    githubId = 66669;
    name = "Jeff Zellner";
  };
  kaiha = {
    email = "kai.harries@gmail.com";
    github = "kaiha";
    githubId = 6544084;
    name = "Kai Harries";
  };
  kalbasit = {
    email = "wael.nasreddine@gmail.com";
    github = "kalbasit";
    githubId = 87115;
    name = "Wael Nasreddine";
  };
  kamadorueda = {
    name = "Kevin Amado";
    email = "kamadorueda@gmail.com";
    github = "kamadorueda";
    githubId = 47480384;
    keys = [{
      longkeyid = "rsa4096/0x04D0CEAF916A9A40";
      fingerprint = "2BE3 BAFD 793E A349 ED1F  F00F 04D0 CEAF 916A 9A40";
    }];
  };
  kamilchm = {
    email = "kamil.chm@gmail.com";
    github = "kamilchm";
    githubId = 1621930;
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
  kayhide = {
    email = "kayhide@gmail.com";
    github = "kayhide";
    githubId = 1730718;
    name = "Hideaki Kawai";
  };
  kazcw = {
    email = "kaz@lambdaverse.org";
    github = "kazcw";
    githubId = 1047859;
    name = "Kaz Wesley";
  };
  kcalvinalvin = {
    email = "calvin@kcalvinalvin.info";
    github = "kcalvinalvin";
    githubId = 37185887;
    name = "Calvin Kim";
  };
  kentjames = {
    email = "jameschristopherkent@gmail.com";
    github = "kentjames";
    githubId = 2029444;
    name = "James Kent";
  };
  kevincox = {
    email = "kevincox@kevincox.ca";
    github = "kevincox";
    githubId = 494012;
    name = "Kevin Cox";
  };
  khumba = {
    email = "bog@khumba.net";
    github = "khumba";
    githubId = 788813;
    name = "Bryan Gardiner";
  };
  KibaFox = {
    email = "kiba.fox@foxypossibilities.com";
    github = "KibaFox";
    githubId = 16481032;
    name = "Kiba Fox";
  };
  kierdavis = {
    email = "kierdavis@gmail.com";
    github = "kierdavis";
    githubId = 845652;
    name = "Kier Davis";
  };
  killercup = {
    email = "killercup@gmail.com";
    github = "killercup";
    githubId = 20063;
    name = "Pascal Hertleif";
  };
  kiloreux = {
    email = "kiloreux@gmail.com";
    github = "kiloreux";
    githubId = 6282557;
    name = "Kiloreux Emperex";
  };
  kim0 = {
    email = "email.ahmedkamal@googlemail.com";
    github = "kim0";
    githubId = 59667;
    name = "Ahmed Kamal";
  };
  kimburgess = {
    email = "kim@acaprojects.com";
    github = "kimburgess";
    githubId = 843652;
    name = "Kim Burgess";
  };
  kini = {
    email = "keshav.kini@gmail.com";
    github = "kini";
    githubId = 691290;
    name = "Keshav Kini";
  };
  kirelagin = {
    email = "kirelagin@gmail.com";
    github = "kirelagin";
    githubId = 451835;
    name = "Kirill Elagin";
  };
  kirikaza = {
    email = "k@kirikaza.ru";
    github = "kirikaza";
    githubId = 804677;
    name = "Kirill Kazakov";
  };
  kisonecat = {
    email = "kisonecat@gmail.com";
    github = "kisonecat";
    githubId = 148352;
    name = "Jim Fowler";
  };
  kiwi = {
    email = "envy1988@gmail.com";
    github = "Kiwi";
    githubId = 35715;
    name = "Robert Djubek";
    keys = [{
      longkeyid = "rsa4096/0x156C88A5B0A04B2A";
      fingerprint = "8992 44FC D291 5CA2 0A97  802C 156C 88A5 B0A0 4B2A";
    }];
  };
  kjuvi = {
    email = "quentin.vaucher@pm.me";
    github = "kjuvi";
    githubId = 17534323;
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
    githubId = 18447310;
  };
  kmcopper = {
    email = "kmcopper@danwin1210.me";
    name = "Kyle Copperfield";
    github = "kmcopper";
    githubId = 57132115;
  };
  kmeakin = {
    email = "karlwfmeakin@gmail.com";
    name = "Karl Meakin";
    github = "Kmeakin";
    githubId = 19665139;
  };

  kmein = {
    email = "kieran.meinhardt@gmail.com";
    name = "Kierán Meinhardt";
    github = "kmein";
    githubId = 10352507;
  };
  knairda = {
    email = "adrian@kummerlaender.eu";
    name = "Adrian Kummerlaender";
    github = "KnairdA";
  };
  knedlsepp = {
    email = "josef.kemetmueller@gmail.com";
    github = "knedlsepp";
    githubId = 3287933;
    name = "Josef Kemetmüller";
  };
  knl = {
    email = "nikola@knezevic.co";
    github = "knl";
    githubId = 361496;
    name = "Nikola Knežević";
  };
  kolaente = {
    email = "k@knt.li";
    github = "kolaente";
    githubId = 13721712;
    name = "Konrad Langenberg";
  };
  konimex = {
    email = "herdiansyah@netc.eu";
    github = "konimex";
    githubId = 15692230;
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
    githubId = 1903418;
    name = "Kovacsics Robert";
  };
  kquick = {
    email = "quick@sparq.org";
    github = "kquick";
    githubId = 787421;
    name = "Kevin Quick";
  };
  kragniz = {
    email = "louis@kragniz.eu";
    github = "kragniz";
    githubId = 735008;
    name = "Louis Taylor";
  };
  krav = {
    email = "kristoffer@microdisko.no";
    github = "krav";
    githubId = 4032;
    name = "Kristoffer Thømt Ravneberg";
  };
  kroell = {
    email = "nixosmainter@makroell.de";
    github = "rokk4";
    githubId = 17659803;
    name = "Matthias Axel Kröll";
  };
  kristoff3r = {
    email = "k.soeholm@gmail.com";
    github = "kristoff3r";
    githubId = 160317;
    name = "Kristoffer Søholm";
  };
  ktf = {
    email = "giulio.eulisse@cern.ch";
    github = "ktf";
    githubId = 10544;
    name = "Giuluo Eulisse";
  };
  ktor = {
    email = "kruszewsky@gmail.com";
    github = "ktor";
    githubId = 99639;
    name = "Pawel Kruszewski";
  };
  ktosiek = {
    email = "tomasz.kontusz@gmail.com";
    github = "ktosiek";
    githubId = 278013;
    name = "Tomasz Kontusz";
  };
  kuznero = {
    email = "roman@kuznero.com";
    github = "kuznero";
    githubId = 449813;
    name = "Roman Kuznetsov";
  };
  kwohlfahrt = {
    email = "kai.wohlfahrt@gmail.com";
    github = "kwohlfahrt";
    githubId = 2422454;
    name = "Kai Wohlfahrt";
  };
  kylesferrazza = {
    name = "Kyle Sferrazza";
    email = "kyle.sferrazza@gmail.com";

    github = "kylesferrazza";
    githubId = 6677292;

    keys = [{
      longkeyid = "rsa4096/81A1540948162372";
      fingerprint = "5A9A 1C9B 2369 8049 3B48  CF5B 81A1 5409 4816 2372";
    }];
  };
  kylewlacy = {
    email = "kylelacy+nix@pm.me";
    github = "kylewlacy";
    githubId = 1362179;
    name = "Kyle Lacy";
  };
  laikq = {
    email = "gwen@quasebarth.de";
    github = "laikq";
    name = "Gwendolyn Quasebarth";
  };
  lasandell = {
    email = "lasandell@gmail.com";
    github = "lasandell";
    githubId = 2034420;
    name = "Luke Sandell";
  };
  lambda-11235 = {
    email = "taranlynn0@gmail.com";
    github = "lambda-11235";
    githubId = 16354815;
    name = "Taran Lynn";
  };
  lassulus = {
    email = "lassulus@gmail.com";
    github = "Lassulus";
    name = "Lassulus";
  };
  lattfein = {
    email = "lattfein@gmail.com";
    # Their GitHub account was deleted.
    #
    # See: https://github.com/NixOS/nixpkgs/pull/69007 where this
    # was added but is now owned by a ghost.
    #
    # Possibly the username lattfein (currently github ID 56827487) is
    # owned by the same person, but we should confirm before adding
    # the GitHub name or ID back.
    # github = "lattfein";
    name = "Koki Yasuno";
  };
  layus = {
    email = "layus.on@gmail.com";
    github = "layus";
    githubId = 632767;
    name = "Guillaume Maudoux";
  };
  lblasc = {
    email = "lblasc@znode.net";
    github = "lblasc";
    githubId = 32152;
    name = "Luka Blaskovic";
  };
  ldesgoui = {
    email = "ldesgoui@gmail.com";
    github = "ldesgoui";
    githubId = 2472678;
    name = "Lucas Desgouilles";
  };
  league = {
    email = "league@contrapunctus.net";
    github = "league";
    githubId = 50286;
    name = "Christopher League";
  };
  leahneukirchen = {
    email = "leah@vuxu.org";
    github = "leahneukirchen";
    githubId = 139;
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
    githubId = 307744;
    name = "Adam Fidel";
  };
  leemachin = {
    email = "me@mrl.ee";
    github = "leemachin";
    githubId = 736291;
    name = "Lee Machin";
  };
  leenaars = {
    email = "ml.software@leenaa.rs";
    github = "leenaars";
    githubId = 4158274;
    name = "Michiel Leenaars";
  };
  lejonet = {
    email = "daniel@kuehn.se";
    github = "lejonet";
    githubId = 567634;
    name = "Daniel Kuehn";
  };
  leo60228 = {
    email = "iakornfeld@gmail.com";
    github = "leo60228";
    githubId = 8355305;
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
    githubId = 480920;
    name = "Luca Bruno";
  };
  lewo = {
    email = "lewo@abesis.fr";
    github = "nlewo";
    githubId = 3425311;
    name = "Antoine Eiche";
  };
  lheckemann = {
    email = "git@sphalerite.org";
    github = "lheckemann";
    githubId = 341954;
    name = "Linus Heckemann";
  };
  lhvwb = {
    email = "nathaniel.baxter@gmail.com";
    github = "nathanielbaxter";
    githubId = 307589;
    name = "Nathaniel Baxter";
  };
  liff = {
    email = "liff@iki.fi";
    github = "liff";
    githubId = 124475;
    name = "Olli Helenius";
  };
  lightbulbjim = {
    email = "chris@killred.net";
    github = "lightbulbjim";
    githubId = 4312404;
    name = "Chris Rendle-Short";
  };
  lightdiscord = {
    email = "root@arnaud.sh";
    github = "lightdiscord";
    githubId = 24509182;
    name = "Arnaud Pascal";
  };
  lihop = {
    email = "nixos@leroy.geek.nz";
    github = "lihop";
    githubId = 3696783;
    name = "Leroy Hopson";
  };
  lilyball = {
    email = "lily@sb.org";
    github = "lilyball";
    githubId = 714;
    name = "Lily Ballard";
  };
  limeytexan = {
    email = "limeytexan@gmail.com";
    github = "limeytexan";
    githubId = 36448130;
    name = "Michael Brantley";
  };
  linarcx = {
    email = "linarcx@gmail.com";
    github = "linarcx";
    githubId = 10884422;
    name = "Kaveh Ahangar";
  };
  linc01n = {
    email = "git@lincoln.hk";
    github = "linc01n";
    githubId = 667272;
    name = "Lincoln Lee";
  };
  linquize = {
    email = "linquize@yahoo.com.hk";
    github = "linquize";
    githubId = 791115;
    name = "Linquize";
  };
  linus = {
    email = "linusarver@gmail.com";
    github = "listx";
    githubId = 725613;
    name = "Linus Arver";
  };
  livnev = {
    email = "lev@liv.nev.org.uk";
    github = "livnev";
    githubId = 3964494;
    name = "Lev Livnev";
    keys = [{
      longkeyid = "rsa2048/0x68FF81E6A7850F49";
      fingerprint = "74F5 E5CC 19D3 B5CB 608F  6124 68FF 81E6 A785 0F49";
    }];
  };
  luis = {
      email = "luis.nixos@gmail.com";
      github = "Luis-Hebendanz";
      githubId = 22085373;
      name = "Luis Hebendanz";
  };
  lionello = {
    email = "lio@lunesu.com";
    github = "lionello";
    githubId = 591860;
    name = "Lionello Lunesu";
  };
  lluchs = {
    email = "lukas.werling@gmail.com";
    github = "lluchs";
    githubId = 516527;
    name = "Lukas Werling";
  };
  lnl7 = {
    email = "daiderd@gmail.com";
    github = "lnl7";
    githubId = 689294;
    name = "Daiderd Jordan";
  };
  lo1tuma = {
    email = "schreck.mathias@gmail.com";
    github = "lo1tuma";
    githubId = 169170;
    name = "Mathias Schreck";
  };
  loewenheim = {
    email = "loewenheim@mailbox.org";
    github = "loewenheim";
    githubId = 7622248;
    name = "Sebastian Zivota";
  };
  lopsided98 = {
    email = "benwolsieffer@gmail.com";
    github = "lopsided98";
    githubId = 5624721;
    name = "Ben Wolsieffer";
  };
  loskutov = {
    email = "ignat.loskutov@gmail.com";
    github = "loskutov";
    githubId = 1202012;
    name = "Ignat Loskutov";
  };
  lovek323 = {
    email = "jason@oconal.id.au";
    github = "lovek323";
    name = "Jason O'Conal";
  };
  lovesegfault = {
    email = "meurerbernardo@gmail.com";
    github = "lovesegfault";
    githubId = 7243783;
    name = "Bernardo Meurer";
    keys = [
      {
        longkeyid = "rsa2048/0xE421C74191EA186C";
        fingerprint = "5894 12CE 19DF 582A E10A  3320 E421 C741 91EA 186C";
      }
      {
        longkeyid = "rsa2048/0x4A6D87A0E7475769";
        fingerprint = "56A8 E164 E834 290C 4AC0  EE3E 4A6D 87A0 E747 5769";
      }
    ];
  };
  lowfatcomputing = {
    email = "andreas.wagner@lowfatcomputing.org";
    github = "lowfatcomputing";
    githubId = 10626;
    name = "Andreas Wagner";
  };
  lschuermann = {
    email = "leon.git@is.currently.online";
    github = "lschuermann";
    githubId = 5341193;
    name = "Leon Schuermann";
  };
  lsix = {
    email = "lsix@lancelotsix.com";
    github = "lsix";
    githubId = 724339;
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
    githubId = 2025623;
    name = "Luc Chabassier";
  };
  lucus16 = {
    email = "lars.jellema@gmail.com";
    github = "Lucus16";
    githubId = 2487922;
    name = "Lars Jellema";
  };
  ludo = {
    email = "ludo@gnu.org";
    github = "civodul";
    githubId = 1168435;
    name = "Ludovic Courtès";
  };
  lufia = {
    email = "lufia@lufia.org";
    github = "lufia";
    githubId = 1784379;
    name = "Kyohei Kadota";
  };
  luispedro = {
    email = "luis@luispedro.org";
    github = "luispedro";
    githubId = 79334;
    name = "Luis Pedro Coelho";
  };
  lukeadams = {
    email = "luke.adams@belljar.io";
    github = "lukeadams";
    githubId = 3508077;
    name = "Luke Adams";
  };
  lukebfox = {
    email = "lbentley-fox1@sheffield.ac.uk";
    github = "lukebfox";
    githubId = 34683288;
    name = "Luke Bentley-Fox";
  };
  lukego = {
    email = "luke@snabb.co";
    github = "lukego";
    githubId = 13791;
    name = "Luke Gorrie";
  };
  lumi = {
    email = "lumi@pew.im";
    github = "lumi-me-not";
    name = "lumi";
  };
  luz = {
    email = "luz666@daum.net";
    github = "Luz";
    githubId = 208297;
    name = "Luz";
  };
  lw = {
    email = "lw@fmap.me";
    github = "lolwat97";
    githubId = 2057309;
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
    githubId = 6025220;
    name = "Maximilian Bosch";
  };
  ma9e = {
    email = "sean@lfo.team";
    github = "furrycatherder";
    githubId = 36235154;
    name = "Sean Haugh";
  };
  madjar = {
    email = "georges.dubus@compiletoi.net";
    github = "madjar";
    githubId = 109141;
    name = "Georges Dubus";
  };
  mafo = {
    email = "Marc.Fontaine@gmx.de";
    github = "MarcFontaine";
    githubId = 1433367;
    name = "Marc Fontaine";
  };
  magenbluten = {
    email = "magenbluten@codemonkey.cc";
    github = "magenbluten";
    githubId = 1140462;
    name = "magenbluten";
  };
  magnetophon = {
    email = "bart@magnetophon.nl";
    github = "magnetophon";
    githubId = 7645711;
    name = "Bart Brouns";
  };
  mahe = {
    email = "matthias.mh.herrmann@gmail.com";
    github = "2chilled";
    githubId = 1238350;
    name = "Matthias Herrmann";
  };
  makefu = {
    email = "makefu@syntax-fehler.de";
    github = "makefu";
    githubId = 115218;
    name = "Felix Richter";
  };
  malyn = {
    email = "malyn@strangeGizmo.com";
    github = "malyn";
    githubId = 346094;
    name = "Michael Alyn Miller";
  };
  manveru = {
    email = "m.fellinger@gmail.com";
    github = "manveru";
    githubId = 3507;
    name = "Michael Fellinger";
  };
  marcweber = {
    email = "marco-oweber@gmx.de";
    github = "marcweber";
    githubId = 34086;
    name = "Marc Weber";
  };
  marcus7070 = {
    email = "marcus@geosol.com.au";
    github = "marcus7070";
    githubId = 50230945;
    name = "Marcus Boyd";
  };
	marenz = {
		email = "marenz@arkom.men";
		github = "marenz2569";
		githubId = 12773269;
		name = "Markus Schmidl";
	};
  markus1189 = {
    email = "markus1189@gmail.com";
    github = "markus1189";
    githubId = 591567;
    name = "Markus Hauck";
  };
  markuskowa = {
    email = "markus.kowalewski@gmail.com";
    github = "markuskowa";
    githubId = 26470037;
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
    githubId = 22586596;
  };
  marsam = {
    email = "marsam@users.noreply.github.com";
    github = "marsam";
    githubId = 65531;
    name = "Mario Rodas";
  };
  martijnvermaat = {
    email = "martijn@vermaat.name";
    github = "martijnvermaat";
    githubId = 623509;
    name = "Martijn Vermaat";
  };
  martingms = {
    email = "martin@mg.am";
    github = "martingms";
    githubId = 458783;
    name = "Martin Gammelsæter";
  };
  marzipankaiser = {
    email = "nixos@gaisseml.de";
    github = "marzipankaiser";
    githubId = 2551444;
    name = "Marcial Gaißert";
    keys = [{
      longkeyid = "rsa2048/0xB629036BE399EEE9";
      fingerprint = "B573 5118 0375 A872 FBBF  7770 B629 036B E399 EEE9";
    }];
  };
  matejc = {
    email = "cotman.matej@gmail.com";
    github = "matejc";
    githubId = 854770;
    name = "Matej Cotman";
  };
  mathnerd314 = {
    email = "mathnerd314.gph+hs@gmail.com";
    github = "mathnerd314";
    githubId = 322214;
    name = "Mathnerd314";
  };
  matklad = {
    email = "aleksey.kladov@gmail.com";
    github = "matklad";
    githubId = 1711539;
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
    githubId = 427866;
    name = "Matthias Beyer";
  };
  matthuszagh = {
    email = "huszaghmatt@gmail.com";
    github = "matthuszagh";
    githubId = 7377393;
    name = "Matt Huszagh";
  };
  matti-kariluoma = {
    email = "matti@kariluo.ma";
    github = "matti-kariluoma";
    name = "Matti Kariluoma";
  };
  maurer = {
    email = "matthew.r.maurer+nix@gmail.com";
    github = "maurer";
    githubId = 136037;
    name = "Matthew Maurer";
  };
  mbakke = {
    email = "mbakke@fastmail.com";
    github = "mbakke";
    githubId = 1269099;
    name = "Marius Bakke";
  };
  mbbx6spp = {
    email = "me@susanpotter.net";
    github = "mbbx6spp";
    githubId = 564;
    name = "Susan Potter";
  };
  mbe = {
    email = "brandonedens@gmail.com";
    github = "brandonedens";
    githubId = 396449;
    name = "Brandon Edens";
  };
  mbode = {
    email = "maxbode@gmail.com";
    github = "mbode";
    githubId = 9051309;
    name = "Maximilian Bode";
  };
  mboes = {
    email = "mboes@tweag.net";
    github = "mboes";
    githubId = 51356;
    name = "Mathieu Boespflug";
  };
  mbrgm = {
    email = "marius@yeai.de";
    github = "mbrgm";
    githubId = 2971615;
    name = "Marius Bergmann";
  };
  mcmtroffaes = {
    email = "matthias.troffaes@gmail.com";
    github = "mcmtroffaes";
    githubId = 158568;
    name = "Matthias C. M. Troffaes";
  };
  McSinyx = {
    email = "vn.mcsinyx@gmail.com";
    github = "McSinyx";
    githubId = 13689192;
    name = "Nguyễn Gia Phong";
  };
  mdaiter = {
    email = "mdaiter8121@gmail.com";
    github = "mdaiter";
    githubId = 1377571;
    name = "Matthew S. Daiter";
  };
  mdevlamynck = {
    email = "matthias.devlamynck@mailoo.org";
    github = "mdevlamynck";
    githubId = 4378377;
    name = "Matthias Devlamynck";
  };
  mdlayher = {
    email = "mdlayher@gmail.com";
    github = "mdlayher";
    githubId = 1926905;
    name = "Matt Layher";
  };
  meditans = {
    email = "meditans@gmail.com";
    github = "meditans";
    githubId = 4641445;
    name = "Carlo Nucera";
  };
  megheaiulian = {
    email = "iulian.meghea@gmail.com";
    github = "megheaiulian";
    githubId = 1788114;
    name = "Meghea Iulian";
  };
  mehandes = {
    email = "niewskici@gmail.com";
    github = "mehandes";
    githubId = 32581276;
    name = "Matt Deming";
  };
  meisternu = {
    email = "meister@krutt.org";
    github = "meisternu";
    githubId = 8263431;
    name = "Matt Miemiec";
  };
  melchips = {
    email = "truphemus.francois@gmail.com";
    github = "melchips";
    githubId = 365721;
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
    githubId = 6412377;
    name = "Samuel Ruprecht";
  };
  metabar = {
    email = "softs@metabarcoding.org";
    name = "Celine Mercier";
  };
  metadark = {
    email = "kira.bruneau@gmail.com";
    name = "Kira Bruneau";
    github = "metadark";
    githubId = 382041;
  };
  mfossen = {
    email = "msfossen@gmail.com";
    github = "mfossen";
    githubId = 3300322;
    name = "Mitchell Fossen";
  };
  mgdelacroix = {
    email = "mgdelacroix@gmail.com";
    github = "mgdelacroix";
    githubId = 223323;
    name = "Miguel de la Cruz";
  };
  mgregoire = {
    email = "gregoire@martinache.net";
    github = "M-Gregoire";
    githubId = 9469313;
    name = "Gregoire Martinache";
  };
  mgttlinger = {
    email = "megoettlinger@gmail.com";
    github = "mgttlinger";
    githubId = 5120487;
    name = "Merlin Göttlinger";
  };
  mguentner = {
    email = "code@klandest.in";
    github = "mguentner";
    githubId = 668926;
    name = "Maximilian Güntner";
  };
   mhaselsteiner = {
    email = "magdalena.haselsteiner@gmx.at";
    github = "mhaselsteiner";
    githubId = 20536514;
    name = "Magdalena Haselsteiner";
  };
  mic92 = {
    email = "joerg@thalheim.io";
    github = "mic92";
    githubId = 96200;
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
    githubId = 4366292;
    name = "Michal Rus";
  };
  michelk = {
    email = "michel@kuhlmanns.info";
    github = "michelk";
    name = "Michel Kuhlmann";
  };
  michojel = {
    email = "mic.liamg@gmail.com";
    github = "michojel";
    githubId = 21156022;
    name = "Michal Minář";
  };
  mickours = {
    email = "mickours@gmail.com<";
    github = "mickours";
    githubId = 837312;
    name = "Michael Mercier";
  };
  midchildan = {
    email = "midchildan+nix@gmail.com";
    github = "midchildan";
    githubId = 7343721;
    name = "midchildan";
  };
  mikefaille = {
    email = "michael@faille.io";
    github = "mikefaille";
    githubId = 978196;
    name = "Michaël Faille";
  };
  mikoim = {
    email = "ek@esh.ink";
    github = "mikoim";
    githubId = 3958340;
    name = "Eshin Kunishima";
  };
  mildlyincompetent = {
    email = "nix@kch.dev";
    github = "mildlyincompetent";
    githubId = 19479662;
    name = "Kajetan Champlewski";
  };
  miltador = {
    email = "miltador@yandex.ua";
    name = "Vasiliy Solovey";
  };
  mimame = {
    email = "miguel.madrid.mencia@gmail.com";
    github = "mimame";
    githubId = 3269878;
    name = "Miguel Madrid Mencía";
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
    githubId = 1776903;
    name = "Andrew Abbott";
  };
  mjanczyk = {
    email = "m@dragonvr.pl";
    github = "mjanczyk";
    githubId = 1001112;
    name = "Marcin Janczyk";
  };
  mjp = {
    email = "mike@mythik.co.uk";
    github = "MikePlayle";
    githubId = 16974598;
    name = "Mike Playle";
  };
  mkaito = {
    email = "chris@mkaito.net";
    github = "mkaito";
    githubId = 20434;
    name = "Christian Höppner";
  };
  mkazulak = {
    email = "kazulakm@gmail.com";
    github = "mulderr";
    githubId = 5698461;
    name = "Maciej Kazulak";
  };
  mkf = {
    email = "m@mikf.pl";
    github = "mkf";
    name = "Michał Krzysztof Feiler";
    keys = [{
      longkeyid = "rsa4096/0xE35C2D7C2C6AC724";
      fingerprint = "1E36 9940 CC7E 01C4 CFE8  F20A E35C 2D7C 2C6A C724";
    }];
  };
  mkg = {
    email = "mkg@vt.edu";
    github = "mkgvt";
    githubId = 22477669;
    name = "Mark K Gardner";
  };
  mkg20001 = {
    email = "mkg20001+nix@gmail.com";
    github = "mkg20001";
    githubId = 7735145;
    name = "Maciej Krüger";
    keys = [{
      longkeyid = "rsa4096/0x0D948CE19CF49C5F";
      fingerprint = "E90C BA34 55B3 6236 740C  038F 0D94 8CE1 9CF4 9C5F";
    }];
  };
  mlieberman85 = {
    email = "mlieberman85@gmail.com";
    github = "mlieberman85";
    githubId = 622577;
    name = "Michael Lieberman";
  };
  mmahut = {
    email = "marek.mahut@gmail.com";
    github = "mmahut";
    githubId = 104795;
    name = "Marek Mahut";
  };
  mmai = {
    email = "henri.bourcereau@gmail.com";
    github = "mmai";
    githubId = 117842;
    name = "Henri Bourcereau";
  };
  mmilata = {
    email = "martin@martinmilata.cz";
    github = "mmilata";
    gitHubId = 85857;
    name = "Martin Milata";
  };
  mmlb = {
    email = "me.mmlb@mmlb.me";
    github = "mmlb";
    name = "Manuel Mendez";
  };
  mnacamura = {
    email = "m.nacamura@gmail.com";
    github = "mnacamura";
    githubId = 45770;
    name = "Mitsuhiro Nakamura";
  };
  moaxcp = {
    email = "moaxcp@gmail.com";
    github = "moaxcp";
    githubId = 7831184;
    name = "John Mercier";
  };
  modulistic = {
    email = "modulistic@gmail.com";
    github = "modulistic";
    githubId = 1902456;
    name = "Pablo Costa";
  };
  mog = {
    email = "mog-lists@rldn.net";
    github = "mogorman";
    githubId = 64710;
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
    githubId = 350116;
    name = "Patrice Clement";
  };
  montag451 = {
    email = "montag451@laposte.net";
    github = "montag451";
    githubId = 249317;
    name = "montag451";
  };
  moosingin3space = {
    email = "moosingin3space@gmail.com";
    github = "moosingin3space";
    githubId = 830082;
    name = "Nathan Moos";
  };
  moredread = {
    email = "code@apb.name";
    github = "moredread";
    githubId = 100848;
    name = "André-Patrick Bubel";
    keys = [{
      longkeyid = "rsa8192/0x118CE7C424B45728";
      fingerprint = "4412 38AD CAD3 228D 876C  5455 118C E7C4 24B4 5728";
    }];
  };
  moretea = {
    email = "maarten@moretea.nl";
    github = "moretea";
    githubId = 99988;
    name = "Maarten Hoogendoorn";
  };
  MostAwesomeDude = {
    email = "cds@corbinsimpson.com";
    github = "MostAwesomeDude";
    githubId = 118035;
    name = "Corbin Simpson";
  };
  mounium = {
    email = "muoniurn@gmail.com";
    github = "mounium";
    githubId = 20026143;
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
    githubId = 2894019;
    name = "Mark Cohen";
  };
  mpickering = {
    email = "matthewtpickering@gmail.com";
    github = "mpickering";
    githubId = 1216657;
    name = "Matthew Pickering";
  };
  mpoquet = {
    email = "millian.poquet@gmail.com";
    github = "mpoquet";
    githubId = 3502831;
    name = "Millian Poquet";
  };
  mpscholten = {
    email = "marc@mpscholten.de";
    github = "mpscholten";
    name = "Marc Scholten";
  };
  mpsyco = {
    email = "fr.st-amour@gmail.com";
    github = "fstamour";
    githubId = 2881922;
    name = "Francis St-Amour";
  };
  mtrsk = {
    email = "marcos.schonfinkel@protonmail.com";
    github = "mtrsk";
    githubId = 16356569;
    name = "Marcos Benevides";
  };
  mredaelli = {
    email = "massimo@typish.io";
    github = "mredaelli";
    name = "Massimo Redaelli";
  };
  mrkkrp = {
    email = "markkarpov92@gmail.com";
    github = "mrkkrp";
    githubId = 8165792;
    name = "Mark Karpov";
  };
  mrmebelman = {
    email = "burzakovskij@protonmail.com";
    github = "MrMebelMan";
    githubId = 15896005;
    name = "Vladyslav Burzakovskyy";
  };
  mrVanDalo = {
    email = "contact@ingolf-wagner.de";
    github = "mrVanDalo";
    githubId = 839693;
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
    githubId = 437005;
    name = "Mikkel Christiansen";
  };
  mschuwalow = {
    github = "mschuwalow";
    githubId = 16665913;
    name = "Maxim Schuwalow";
    email = "maxim.schuwalow@gmail.com";
  };
  msiedlarek = {
    email = "mikolaj@siedlarek.pl";
    github = "msiedlarek";
    githubId = 133448;
    name = "Mikołaj Siedlarek";
  };
  mstarzyk = {
    email = "mstarzyk@gmail.com";
    github = "mstarzyk";
    githubId = 111304;
    name = "Maciek Starzyk";
  };
  msteen = {
    email = "emailmatthijs@gmail.com";
    github = "msteen";
    githubId = 788953;
    name = "Matthijs Steen";
  };
  mt-caret = {
    email = "mtakeda.enigsol@gmail.com";
    github = "mt-caret";
    githubId = 4996739;
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
    githubId = 39034;
    name = "Max Treskin";
  };
  mudri = {
    email = "lamudri@gmail.com";
    github = "laMudri";
    githubId = 5139265;
    name = "James Wood";
  };
  muflax = {
    email = "mail@muflax.com";
    github = "muflax";
    githubId = 69918;
    name = "Stefan Dorn";
  };
  multun = {
    email = "victor.collod@epita.fr";
    github = "multun";
    githubId = 5047140;
    name = "Victor Collod";
  };
  mvnetbiz = {
    email = "mvnetbiz@gmail.com";
    github = "mvnetbiz";
    githubId = 6455574;
    name = "Matt Votava";
  };
  mwilsoninsight = {
    email = "max.wilson@insight.com";
    github = "mwilsoninsight";
    githubId = 47782621;
    name = "Max Wilson";
  };
  myrl = {
    email = "myrl.0xf@gmail.com";
    github = "myrl";
    githubId = 9636071;
    name = "Myrl Hex";
  };
  nadrieril = {
    email = "nadrieril@gmail.com";
    github = "nadrieril";
    githubId = 6783654;
    name = "Nadrieril Feneanar";
  };
  nalbyuites = {
    email = "ashijit007@gmail.com";
    github = "nalbyuites";
    githubId = 1009523;
    name = "Ashijit Pramanik";
  };
  namore = {
    email = "namor@hemio.de";
    github = "namore";
    githubId = 1222539;
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
    githubId = 330943;
    name = "Nathan Bijnens";
  };
  nathyong = {
    email = "nathyong@noreply.github.com";
    github = "nathyong";
    githubId = 818502;
    name = "Nathan Yong";
  };
  nckx = {
    email = "github@tobias.gr";
    github = "nckx";
    githubId = 364510;
    name = "Tobias Geerinckx-Rice";
  };
  neeasade = {
    email = "nathanisom27@gmail.com";
    github = "neeasade";
    githubId = 3747396;
    name = "Nathan Isom";
  };
  neonfuz = {
    email = "neonfuz@gmail.com";
    github = "neonfuz";
    githubId = 2590830;
    name = "Sage Raflik";
  };
  nequissimus = {
    email = "tim@nequissimus.com";
    github = "nequissimus";
    githubId = 628342;
    name = "Tim Steinbach";
  };
  netixx = {
    email = "dev.espinetfrancois@gmail.com";
    github = "netixx";
    githubId = 1488603;
    name = "François Espinet";
  };
  nikitavoloboev = {
    email = "nikita.voloboev@gmail.com";
    github = "nikitavoloboev";
    githubId = 6391776;
    name = "Nikita Voloboev";
  };
  nfjinjing = {
    email = "nfjinjing@gmail.com";
    name = "Jinjing Wang";
  };
  nh2 = {
    email = "mail@nh2.me";
    github = "nh2";
    githubId = 399535;
    name = "Niklas Hambüchen";
  };
  nhooyr = {
    email = "anmol@aubble.com";
    github = "nhooyr";
    githubId = 10180857;
    name = "Anmol Sethi";
  };
  nickhu = {
    email = "me@nickhu.co.uk";
    github = "nickhu";
    githubId = 450276;
    name = "Nick Hu";
  };
  nicknovitski = {
    email = "nixpkgs@nicknovitski.com";
    github = "nicknovitski";
    githubId = 151337;
    name = "Nick Novitski";
  };
  nico202 = {
    email = "anothersms@gmail.com";
    github = "nico202";
    githubId = 8214542;
    name = "Nicolò Balzarotti";
  };
  NikolaMandic = {
    email = "nikola@mandic.email";
    github = "NikolaMandic";
    githubId = 4368690;
    name = "Ratko Mladic";
  };
  ninjatrappeur = {
    email = "felix@alternativebit.fr";
    github = "ninjatrappeur";
    githubId = 1219785;
    name = "Félix Baylac-Jacqué";
  };
  nioncode = {
    email = "nioncode+github@gmail.com";
    github = "nioncode";
    githubId = 3159451;
    name = "Nicolas Schneider";
  };
  nipav = {
    email = "niko.pavlinek@gmail.com";
    github = "nipav";
    githubId = 16385648;
    name = "Niko Pavlinek";
  };
  nixy = {
    email = "nixy@nixy.moe";
    github = "nixy";
    githubId = 7588406;
    name = "Andrew R. M.";
  };
  nloomans = {
    email = "noah@nixos.noahloomans.com";
    github = "nloomans";
    githubId = 7829481;
    name = "Noah Loomans";
  };
  nmattia = {
    email = "nicolas@nmattia.com";
    github = "nmattia";
    githubId = 6930756;
    name = "Nicolas Mattia";
  };
  nocent = {
    email = "nocent@protonmail.ch";
    github = "nocent";
    githubId = 25505957;
    name = "nocent";
  };
  nocoolnametom = {
    email = "nocoolnametom@gmail.com";
    github = "nocoolnametom";
    githubId = 810877;
    name = "Tom Doggett";
  };
  nomeata = {
    email = "mail@joachim-breitner.de";
    github = "nomeata";
    githubId = 148037;
    name = "Joachim Breitner";
  };
  noneucat = {
    email = "andy@lolc.at";
    github = "noneucat";
    githubId = 40049608;
    name = "Andy Chun";
  };
  notthemessiah = {
    email = "brian.cohen.88@gmail.com";
    github = "notthemessiah";
    githubId = 2946283;
    name = "Brian Cohen";
  };
  novoxudonoser = {
    email = "radnovox@gmail.com";
    github = "novoxudonoser";
    githubId = 6052922;
    name = "Kirill Struokov";
  };
  np = {
    email = "np.nix@nicolaspouillard.fr";
    github = "np";
    githubId = 5548;
    name = "Nicolas Pouillard";
  };
  nphilou = {
    email = "nphilou@gmail.com";
    github = "nphilou";
    githubId = 9939720;
    name = "Philippe Nguyen";
  };
  nrdxp = {
    email = "tim.deh@pm.me";
    github = "nrdxp";
    githubId = 34083928;
    name = "Tim DeHerrera";
  };
  nshalman = {
    email = "nahamu@gmail.com";
    github = "nshalman";
    githubId = 20391;
    name = "Nahum Shalman";
  };
  nslqqq = {
    email = "nslqqq@gmail.com";
    name = "Nikita Mikhailov";
  };
  nthorne = {
    email = "notrupertthorne@gmail.com";
    github = "nthorne";
    githubId = 1839979;
    name = "Niklas Thörne";
  };
  numinit = {
    email = "me@numin.it";
    github = "numinit";
    githubId = 369111;
    name = "Morgan Jones";
  };
  nyanloutre = {
    email = "paul@nyanlout.re";
    github = "nyanloutre";
    githubId = 7677321;
    name = "Paul Trehiou";
  };
  nyarly = {
    email = "nyarly@gmail.com";
    github = "nyarly";
    githubId = 127548;
    name = "Judson Lester";
  };
  nzhang-zh = {
    email = "n.zhang.hp.au@gmail.com";
    github = "nzhang-zh";
    githubId = 30825096;
    name = "Ning Zhang";
  };
  obadz = {
    email = "obadz-nixos@obadz.com";
    github = "obadz";
    githubId = 3359345;
    name = "obadz";
  };
  ocharles = {
    email = "ollie@ocharles.org.uk";
    github = "ocharles";
    githubId = 20878;
    name = "Oliver Charles";
  };
  odi = {
    email = "oliver.dunkl@gmail.com";
    github = "odi";
    githubId = 158758;
    name = "Oliver Dunkl";
  };
  offline = {
    email = "jaka@x-truder.net";
    github = "offlinehacker";
    githubId = 585547;
    name = "Jaka Hudoklin";
  };
  oida = {
    email = "oida@posteo.de";
    github = "oida";
    githubId = 7249506;
    name = "oida";
  };
  okasu = {
    email = "oka.sux@gmail.com";
    name = "Okasu";
  };
  olcai = {
    email = "dev@timan.info";
    github = "olcai";
    githubId = 20923;
    name = "Erik Timan";
  };
  olejorgenb = {
    email = "olejorgenb@yahoo.no";
    github = "olejorgenb";
    githubId = 72201;
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
    githubId = 1538622;
    name = "Michael Reilly";
  };
  OPNA2608 = {
    email = "christoph.neidahl@gmail.com";
    github = "OPNA2608";
    githubId = 23431373;
    name = "Christoph Neidahl";
  };
  orbekk = {
    email = "kjetil.orbekk@gmail.com";
    github = "orbekk";
    githubId = 19862;
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
    githubId = 101514;
    name = "Orivej Desh";
  };
  osener = {
    email = "ozan@ozansener.com";
    github = "osener";
    githubId = 111265;
    name = "Ozan Sener";
  };
  otwieracz = {
    email = "slawek@otwiera.cz";
    github = "otwieracz";
    githubId = 108072;
    name = "Slawomir Gonet";
  };
  oxij = {
    email = "oxij@oxij.org";
    github = "oxij";
    githubId = 391919;
    name = "Jan Malakhovski";
    keys = [{
      longkeyid = "rsa2048/0x0E6CA66E5C557AA8";
      fingerprint = "514B B966 B46E 3565 0508  86E8 0E6C A66E 5C55 7AA8";
    }];
  };
  oyren = {
    email = "m.scheuren@oyra.eu";
    github = "oyren";
    githubId = 15930073;
    name = "Moritz Scheuren";
  };
  pacien = {
    email = "b4gx3q.nixpkgs@pacien.net";
    github = "pacien";
    githubId = 1449319;
    name = "Pacien Tran-Girard";
  };
  paddygord = {
    email = "pgpatrickgordon@gmail.com";
    github = "paddygord";
    githubId = 10776658;
    name = "Patrick Gordon";
  };
  paholg = {
    email = "paho@paholg.com";
    github = "paholg";
    githubId = 4908217;
    name = "Paho Lurie-Gregg";
  };
  pakhfn = {
    email = "pakhfn@gmail.com";
    github = "pakhfn";
    githubId = 11016164;
    name = "Fedor Pakhomov";
  };
  pamplemousse = {
    email = "xav.maso@gmail.com";
    github = "Pamplemousse";
    githubId = 2647236;
    name = "Xavier Maso";
  };
  panaeon = {
    email = "vitalii.voloshyn@gmail.com";
    github = "panaeon";
    githubId = 686076;
    name = "Vitalii Voloshyn";
  };
  pandaman = {
    email = "kointosudesuyo@infoseek.jp";
    github = "pandaman64";
    githubId = 1788628;
    name = "pandaman";
  };
  paperdigits = {
    email = "mica@silentumbrella.com";
    github = "paperdigits";
    githubId = 71795;
    name = "Mica Semrick";
  };
  paraseba = {
    email = "paraseba@gmail.com";
    github = "paraseba";
    githubId = 20792;
    name = "Sebastian Galkin";
  };
  pashashocky = {
    email = "pashashocky@gmail.com";
    github = "pashashocky";
    githubId = 673857;
    name = "Pash Shocky";
  };
  pashev = {
    email = "pashev.igor@gmail.com";
    github = "ip1981";
    githubId = 131844;
    name = "Igor Pashev";
  };
  patternspandemic = {
    email = "patternspandemic@live.com";
    github = "patternspandemic";
    githubId = 15645854;
    name = "Brad Christensen";
  };
  pawelpacana = {
    email = "pawel.pacana@gmail.com";
    github = "pawelpacana";
    githubId = 116740;
    name = "Paweł Pacana";
  };
  pbogdan = {
    email = "ppbogdan@gmail.com";
    github = "pbogdan";
    githubId = 157610;
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
    githubId = 152312;
    name = "Periklis Tsirakidis";
  };
  pesterhazy = {
    email = "pesterhazy@gmail.com";
    github = "pesterhazy";
    githubId = 106328;
    name = "Paulus Esterhazy";
  };
  petabyteboy = {
    email = "me@pbb.lc";
    github = "petabyteboy";
    githubId = 3250809;
    name = "Milan Pässler";
  };
  peterhoeg = {
    email = "peter@hoeg.com";
    github = "peterhoeg";
    githubId = 722550;
    name = "Peter Hoeg";
  };
  peterromfeldhk = {
    email = "peter.romfeld.hk@gmail.com";
    github = "peterromfeldhk";
    githubId = 5515707;
    name = "Peter Romfeld";
  };
  peti = {
    email = "simons@cryp.to";
    github = "peti";
    githubId = 28323;
    name = "Peter Simons";
  };
  philandstuff = {
    email = "philip.g.potter@gmail.com";
    github = "philandstuff";
    githubId = 581269;
    name = "Philip Potter";
  };
  phile314 = {
    email = "nix@314.ch";
    github = "phile314";
    githubId = 1640697;
    name = "Philipp Hausmann";
  };
  Phlogistique = {
    email = "noe.rubinstein@gmail.com";
    github = "Phlogistique";
    githubId = 421510;
    name = "Noé Rubinstein";
  };
  phreedom = {
    email = "phreedom@yandex.ru";
    github = "phreedom";
    githubId = 62577;
    name = "Evgeny Egorochkin";
  };
  phryneas = {
    email = "mail@lenzw.de";
    github = "phryneas";
    githubId = 4282439;
    name = "Lenz Weber";
  };
  phunehehe = {
    email = "phunehehe@gmail.com";
    github = "phunehehe";
    githubId = 627831;
    name = "Hoang Xuan Phu";
  };
  pierrechevalier83 = {
    email = "pierrechevalier83@gmail.com";
    github = "pierrechevalier83";
    githubId = 5790907;
    name = "Pierre Chevalier";
  };
  pierreis = {
    email = "pierre@pierre.is";
    github = "pierreis";
    githubId = 203973;
    name = "Pierre Matri";
  };
  pierrer = {
    email = "pierrer@pi3r.be";
    github = "pierrer";
    githubId = 93115;
    name = "Pierre Radermecker";
  };
  pierron = {
    email = "nixos@nbp.name";
    github = "nbp";
    githubId = 1179566;
    name = "Nicolas B. Pierron";
  };
  pingiun = {
    email = "nixos@pingiun.com";
    github = "pingiun";
    githubId = 1576660;
    name = "Jelle Besseling";
    keys = [{
      longkeyid = "rsa4096/0x9712452E8BE3372E";
      fingerprint = "A3A3 65AE 16ED A7A0 C29C  88F1 9712 452E 8BE3 372E";
    }];
  };
  piotr = {
    email = "ppietrasa@gmail.com";
    name = "Piotr Pietraszkiewicz";
  };
  pjbarnoy = {
    email = "pjbarnoy@gmail.com";
    github = "pjbarnoy";
    githubId = 119460;
    name = "Perry Barnoy";
  };
  pjones = {
    email = "pjones@devalot.com";
    github = "pjones";
    githubId = 3737;
    name = "Peter Jones";
  };
  pkmx = {
    email = "pkmx.tw@gmail.com";
    github = "pkmx";
    githubId = 610615;
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
    githubId = 358550;
    name = "Philip Lykke Carlsen";
  };
  plumps = {
    email = "maks.bronsky@web.de";
    github = "plumps";
    githubId = 13000278;
    name = "Maksim Bronsky";
  };
  pmahoney = {
    email = "pat@polycrystal.org";
    github = "pmahoney";
    githubId = 103822;
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
    githubId = 178496;
    name = "Philipp Middendorf";
  };
  pmyjavec = {
    email = "pauly@myjavec.com";
    github = "pmyjavec";
    githubId = 315096;
    name = "Pauly Myjavec";
  };
  pnelson = {
    email = "me@pnelson.ca";
    github = "pnelson";
    githubId = 579773;
    name = "Philip Nelson";
  };
  pneumaticat = {
    email = "kevin@potatofrom.space";
    github = "pneumaticat";
    githubId = 11365056;
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
    githubId = 138074;
    name = "Pedro Pombeiro";
  };
  pradeepchhetri = {
    email = "pradeep.chhetri89@gmail.com";
    github = "pradeepchhetri";
    githubId = 2232667;
    name = "Pradeep Chhetri";
  };
  pradyuman = {
    email = "me@pradyuman.co";
    github = "pradyuman";
    githubId = 9904569;
    name = "Pradyuman Vig";
    keys = [
      { longkeyid = "rsa4096/4F74D5361C4CA31E";
        fingerprint = "240B 57DE 4271 2480 7CE3  EAC8 4F74 D536 1C4C A31E";
      }
    ];
  };
  prikhi = {
    email = "pavan.rikhi@gmail.com";
    github = "prikhi";
    githubId = 1304102;
    name = "Pavan Rikhi";
  };
  primeos = {
    email = "dev.primeos@gmail.com";
    github = "primeos";
    githubId = 7537109;
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
    githubId = 3153638;
    name = "Profpatsch";
  };
  proglodyte = {
    email = "proglodyte23@gmail.com";
    github = "proglodyte";
    githubId = 18549627;
    name = "Proglodyte";
  };
  protoben = {
    email = "protob3n@gmail.com";
    github = "protoben";
    githubId = 4633847;
    name = "Ben Hamlin";
  };
  prusnak = {
    email = "pavol@rusnak.io";
    github = "prusnak";
    githubId = 42201;
    name = "Pavol Rusnak";
    keys = [{
      longkeyid = "rsa4096/0x91F3B339B9A02A3D";
      fingerprint = "86E6 792F C27B FD47 8860  C110 91F3 B339 B9A0 2A3D";
    }];
  };
  pshendry = {
    email = "paul@pshendry.com";
    github = "pshendry";
    githubId = 1829032;
    name = "Paul Hendry";
  };
  psibi = {
    email = "sibi@psibi.in";
    github = "psibi";
    githubId = 737477;
    name = "Sibi";
  };
  pstn = {
    email = "philipp@xndr.de";
    name = "Philipp Steinpaß";
  };
  pSub = {
    email = "mail@pascal-wittmann.de";
    github = "pSub";
    githubId = 83842;
    name = "Pascal Wittmann";
  };
  psyanticy = {
    email = "iuns@outlook.fr";
    github = "PsyanticY";
    githubId = 20524473;
    name = "Psyanticy";
  };
  ptival = {
    email = "valentin.robert.42@gmail.com";
    github = "Ptival";
    githubId = 478606;
    name = "Valentin Robert";
  };
  ptrhlm = {
    email = "ptrhlm0@gmail.com";
    github = "ptrhlm";
    githubId = 9568176;
    name = "Piotr Halama";
  };
  puckipedia = {
    email = "puck@puckipedia.com";
    github = "puckipedia";
    githubId = 488734;
    name = "Puck Meerburg";
  };
  puffnfresh = {
    email = "brian@brianmckenna.org";
    github = "puffnfresh";
    githubId = 37715;
    name = "Brian McKenna";
  };
  pxc = {
    email = "patrick.callahan@latitudeengineering.com";
    name = "Patrick Callahan";
  };
  pyrolagus = {
    email = "pyrolagus@gmail.com";
    github = "PyroLagus";
    githubId = 4579165;
    name = "Danny Bautista";
  };
  q3k = {
    email = "q3k@q3k.org";
    github = "q3k";
    githubId = 315234;
    name = "Serge Bazanski";
  };
  qknight = {
    email = "js@lastlog.de";
    github = "qknight";
    githubId = 137406;
    name = "Joachim Schiele";
  };
  qoelet = {
    email = "kenny@machinesung.com";
    github = "qoelet";
    githubId = 115877;
    name = "Kenny Shen";
  };
  qyliss = {
    email = "hi@alyssa.is";
    github = "alyssais";
    githubId = 2768870;
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
    githubId = 1246959;
    name = "Raquel García";
  };
  ragge = {
    email = "r.dahlen@gmail.com";
    github = "ragnard";
    githubId = 882;
    name = "Ragnar Dahlen";
  };
  ralith = {
    email = "ben.e.saunders@gmail.com";
    github = "ralith";
    githubId = 104558;
    name = "Benjamin Saunders";
  };
  ramkromberg = {
    email = "ramkromberg@mail.com";
    github = "ramkromberg";
    githubId = 14829269;
    name = "Ram Kromberg";
  };
  rardiol = {
    email = "ricardo.ardissone@gmail.com";
    github = "rardiol";
    githubId = 11351304;
    name = "Ricardo Ardissone";
  };
  rasendubi = {
    email = "rasen.dubi@gmail.com";
    github = "rasendubi";
    githubId = 1366419;
    name = "Alexey Shmalko";
  };
  raskin = {
    email = "7c6f434c@mail.ru";
    github = "7c6f434c";
    githubId = 1891350;
    name = "Michael Raskin";
  };
  ravloony = {
    email = "ravloony@gmail.com";
    name = "Tom Macdonald";
  };
  rawkode = {
    email = "david.andrew.mckay@gmail.com";
    github = "rawkode";
    githubId = 145816;
    name = "David McKay";
  };
  razvan = {
    email = "razvan.panda@gmail.com";
    github = "razvan-panda";
    githubId = 1758708;
    name = "Răzvan Flavius Panda";
  };
  rbasso = {
    email = "rbasso@sharpgeeks.net";
    github = "rbasso";
    githubId = 16487165;
    name = "Rafael Basso";
  };
  rbrewer = {
    email = "rwb123@gmail.com";
    github = "rbrewer123";
    githubId = 743058;
    name = "Rob Brewer";
  };
  rdnetto = {
    email = "rdnetto@gmail.com";
    github = "rdnetto";
    githubId = 1973389;
    name = "Reuben D'Netto";
  };
  redbaron = {
    email = "ivanov.maxim@gmail.com";
    github = "redbaron";
    githubId = 16624;
    name = "Maxim Ivanov";
  };
  redfish64 = {
    email = "engler@gmail.com";
    github = "redfish64";
    githubId = 1922770;
    name = "Tim Engler";
  };
  redvers = {
    email = "red@infect.me";
    github = "redvers";
    githubId = 816465;
    name = "Redvers Davies";
  };
  refnil = {
    email = "broemartino@gmail.com";
    github = "refnil";
    githubId = 1142322;
    name = "Martin Lavoie";
  };
  regnat = {
    email = "regnat@regnat.ovh";
    github = "regnat";
    githubId = 7226587;
    name = "Théophane Hufschmitt";
  };
  relrod = {
    email = "ricky@elrod.me";
    github = "relrod";
    githubId = 43930;
    name = "Ricky Elrod";
  };
  rembo10 = {
    email = "rembo10@users.noreply.github.com";
    github = "rembo10";
    githubId = 801525;
    name = "rembo10";
  };
  renatoGarcia = {
    email = "fgarcia.renato@gmail.com";
    github = "renatoGarcia";
    githubId = 220211;
    name = "Renato Garcia";
  };
  rencire = {
    email = "546296+rencire@users.noreply.github.com";
    github = "rencire";
    githubId = 546296;
    name = "Eric Ren";
  };
  renzo = {
    email = "renzocarbonara@gmail.com";
    github = "k0001";
    githubId = 3302;
    name = "Renzo Carbonara";
  };
  retrry = {
    email = "retrry@gmail.com";
    github = "retrry";
    githubId = 500703;
    name = "Tadas Barzdžius";
  };
  rexim = {
    email = "reximkut@gmail.com";
    github = "rexim";
    githubId = 165283;
    name = "Alexey Kutepov";
  };
  rht = {
    email = "rhtbot@protonmail.com";
    github = "rht";
    githubId = 395821;
    name = "rht";
  };
  richardipsum = {
    email = "richardipsum@fastmail.co.uk";
    github = "richardipsum";
    githubId = 10631029;
    name = "Richard Ipsum";
  };
  rick68 = {
    email = "rick68@gmail.com";
    github = "rick68";
    githubId = 42619;
    name = "Wei-Ming Yang";
  };
  rickynils = {
    email = "rickynils@gmail.com";
    github = "rickynils";
    name = "Rickard Nilsson";
  };
  rika = {
    email = "rika@paymentswit.ch";
    github = "NekomimiScience";
    githubId = 1810487;
    name = "Rika";
  };
  rileyinman = {
    email = "rileyminman@gmail.com";
    github = "rileyinman";
    githubId = 37246692;
    name = "Riley Inman";
  };
  ris = {
    email = "code@humanleg.org.uk";
    github = "risicle";
    githubId = 807447;
    name = "Robert Scott";
  };
  rittelle = {
    email = "rittelle@posteo.de";
    github = "rittelle";
    githubId = 33598633;
    name = "Lennart Rittel";
  };
  rixed = {
    email = "rixed-github@happyleptic.org";
    github = "rixed";
    githubId = 449990;
    name = "Cedric Cellier";
  };
  rkoe = {
    email = "rk@simple-is-better.org";
    github = "rkoe";
    githubId = 2507744;
    name = "Roland Koebler";
  };
  rlupton20 = {
    email = "richard.lupton@gmail.com";
    github = "rlupton20";
    githubId = 13752145;
    name = "Richard Lupton";
  };
  rnhmjoj = {
    email = "rnhmjoj@inventati.org";
    github = "rnhmjoj";
    githubId = 2817565;
    name = "Michele Guerini Rocco";
    keys =
    [
      { longkeyid   = "ed25519/0xBFBAF4C975F76450";
        fingerprint = "92B2 904F D293 C94D C4C9  3E6B BFBA F4C9 75F7 6450";
      }
    ];
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
    githubId = 12312980;
    name = "Robbin C.";
  };
  roberth = {
    email = "nixpkgs@roberthensing.nl";
    github = "roberth";
    githubId = 496447;
    name = "Robert Hensing";
  };
  robertodr = {
    email = "roberto.diremigio@gmail.com";
    github = "robertodr";
    githubId = 3708689;
    name = "Roberto Di Remigio";
  };
  robgssp = {
    email = "robgssp@gmail.com";
    github = "robgssp";
    githubId = 521306;
    name = "Rob Glossop";
  };
  roblabla = {
    email = "robinlambertz+dev@gmail.com";
    github = "roblabla";
    githubId = 1069318;
    name = "Robin Lambertz";
  };
  roconnor = {
    email = "roconnor@theorem.ca";
    github = "roconnor";
    githubId = 852967;
    name = "Russell O'Connor";
  };
  roelvandijk = {
    email = "roel@lambdacube.nl";
    github = "roelvandijk";
    githubId = 710906;
    name = "Roel van Dijk";
  };
  romildo = {
    email = "malaquias@gmail.com";
    github = "romildo";
    githubId = 1217934;
    name = "José Romildo Malaquias";
  };
  rongcuid = {
    email = "rongcuid@outlook.com";
    github = "rongcuid";
    githubId = 1312525;
    name = "Rongcui Dong";
  };
  roosemberth = {
    email = "roosembert.palacios+nixpkgs@gmail.com";
    github = "roosemberth";
    githubId = 3621083;
    name = "Roosembert (Roosemberth) Palacios";
  };
  royneary = {
    email = "christian@ulrich.earth";
    github = "royneary";
    githubId = 1942810;
    name = "Christian Ulrich";
  };
  rprospero = {
    email = "rprospero+nix@gmail.com";
    github = "rprospero";
    githubId = 1728853;
    name = "Adam Washington";
  };
  rps = {
    email = "robbpseaton@gmail.com";
    github = "robertseaton";
    githubId = 221121;
    name = "Robert P. Seaton";
  };
  rszibele = {
    email = "richard@szibele.com";
    github = "rszibele";
    githubId = 1387224;
    name = "Richard Szibele";
  };
  rtreffer = {
    email = "treffer+nixos@measite.de";
    github = "rtreffer";
    githubId = 61306;
    name = "Rene Treffer";
  };
  rushmorem = {
    email = "rushmore@webenchanter.com";
    github = "rushmorem";
    githubId = 4958190;
    name = "Rushmore Mushambi";
  };
  ruuda = {
    email = "dev+nix@veniogames.com";
    github = "ruuda";
    githubId = 506953;
    name = "Ruud van Asseldonk";
  };
  rvl = {
    email = "dev+nix@rodney.id.au";
    github = "rvl";
    githubId = 1019641;
    name = "Rodney Lorrimar";
  };
  rvlander = {
    email = "rvlander@gaetanandre.eu";
    github = "rvlander";
    githubId = 5236428;
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
    githubId = 889991;
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
    githubId = 4804;
    name = "Ryan Mulligan";
  };
  ryantrinkle = {
    email = "ryan.trinkle@gmail.com";
    github = "ryantrinkle";
    githubId = 1156448;
    name = "Ryan Trinkle";
  };
  rybern = {
    email = "ryan.bernstein@columbia.edu";
    github = "rybern";
    githubId = 4982341;
    name = "Ryan Bernstein";
  };
  rycee = {
    email = "robert@rycee.net";
    github = "rycee";
    githubId = 798147;
    name = "Robert Helgesson";
    keys = [{
      longkeyid = "rsa4096/0x3573356C25C424D4";
      fingerprint = "36CA CF52 D098 CC0E 78FB  0CB1 3573 356C 25C4 24D4";
    }];
  };
  ryneeverett = {
    email = "ryneeverett@gmail.com";
    github = "ryneeverett";
    githubId = 3280280;
    name = "Ryne Everett";
  };
  rzetterberg = {
    email = "richard.zetterberg@gmail.com";
    github = "rzetterberg";
    githubId = 766350;
    name = "Richard Zetterberg";
  };
  samdroid-apps = {
    email = "sam@sam.today";
    github = "samdroid-apps";
    githubId = 6022042;
    name = "Sam Parkinson";
  };
  samrose = {
   email = "samuel.rose@gmail.com";
   github = "samrose";
   githubId = 115821;
   name = "Sam Rose";
  };
  samueldr = {
    email = "samuel@dionne-riel.com";
    github = "samueldr";
    githubId = 132835;
    name = "Samuel Dionne-Riel";
  };
  samuelrivas = {
    email = "samuelrivas@gmail.com";
    github = "samuelrivas";
    githubId = 107703;
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
    githubId = 178904;
    name = "Daniel Ehlers";
  };
  saschagrunert = {
    email = "mail@saschagrunert.de";
    github = "saschagrunert";
    githubId = 695473;
    name = "Sascha Grunert";
  };
  sauyon = {
    email = "s@uyon.co";
    github = "sauyon";
    githubId = 2347889;
    name = "Sauyon Lee";
  };
  sb0 = {
    email = "sb@m-labs.hk";
    github = "sbourdeauducq";
    githubId = 720864;
    name = "Sébastien Bourdeauducq";
  };
  sboosali = {
    email = "SamBoosalis@gmail.com";
    github = "sboosali";
    githubId = 2320433;
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
    githubId = 354463;
    name = "Fabian Schmitthenner";
  };
  schmittlauch = {
    email = "t.schmittlauch+nixos@orlives.de";
    github = "schmittlauch";
  };
  schneefux = {
    email = "schneefux+nixos_pkg@schneefux.xyz";
    github = "schneefux";
    githubId = 15379000;
    name = "schneefux";
  };
  schristo = {
    email = "schristopher@konputa.com";
    name = "Scott Christopher";
  };
  scode = {
    email = "peter.schuller@infidyne.com";
    github = "scode";
    githubId = 59476;
    name = "Peter Schuller";
  };
  scolobb = {
    email = "sivanov@colimite.fr";
    github = "scolobb";
    githubId = 11320;
    name = "Sergiu Ivanov";
  };
  screendriver = {
    email = "nix@echooff.de";
    github = "screendriver";
    githubId = 149248;
    name = "Christian Rackerseder";
  };
  Scriptkiddi = {
    email = "nixos@scriptkiddi.de";
    github = "scriptkiddi";
    githubId = 3598650;
    name = "Fritz Otlinghaus";
  };
  scubed2 = {
    email = "scubed2@gmail.com";
    github = "scubed2";
    name = "Sterling Stein";
  };
  sdier = {
    email = "scott@dier.name";
    github = "sdier";
    githubId = 11613056;
    name = "Scott Dier";
  };
  sdll = {
    email = "sasha.delly@gmail.com";
    github = "sdll";
    githubId = 17913919;
    name = "Sasha Illarionov";
  };
  SeanZicari = {
    email = "sean.zicari@gmail.com";
    github = "SeanZicari";
    githubId = 2343853;
    name = "Sean Zicari";
  };
  sellout = {
    email = "greg@technomadic.org";
    github = "sellout";
    githubId = 33031;
    name = "Greg Pfeil";
  };
  sengaya = {
    email = "tlo@sengaya.de";
    github = "sengaya";
    githubId = 1286668;
    name = "Thilo Uttendorfer";
  };
  sephalon = {
    email = "me@sephalon.net";
    github = "sephalon";
    githubId = 893474;
    name = "Stefan Wiehler";
  };
  sepi = {
    email = "raffael@mancini.lu";
    github = "sepi";
    githubId = 529649;
    name = "Raffael Mancini";
  };
  seppeljordan = {
    email = "sebastian.jordan.mail@googlemail.com";
    github = "seppeljordan";
    githubId = 4805746;
    name = "Sebastian Jordan";
  };
  seqizz = {
    email = "seqizz@gmail.com";
    github = "seqizz";
    githubId = 307899;
    name = "Gurkan Gur";
  };
  servalcatty = {
    email = "servalcat@pm.me";
    github = "servalcatty";
    githubid = 51969817;
    name = "Serval";
    keys = [{
      longkeyid = "rsa4096/0x4A2AAAA382F8294C";
      fingerprint = "A317 37B3 693C 921B 480C  C629 4A2A AAA3 82F8 294C";
    }];
  };
  sfrijters = {
    email = "sfrijters@gmail.com";
    github = "sfrijters";
    githubId = 918365;
    name = "Stefan Frijters";
  };
  sgo = {
    email = "stig@stig.io";
    github = "stigtsp";
    githubId = 75371;
    name = "Stig Palmquist";
  };
  sgraf = {
    email = "sgraf1337@gmail.com";
    github = "sgraf812";
    githubId = 1151264;
    name = "Sebastian Graf";
  };
  shahrukh330 = {
    email = "shahrukh330@gmail.com";
    github = "shahrukh330";
    githubId = 1588288;
    name = "Shahrukh Khan";
  };
  shanemikel = {
    email = "shanepearlman@pm.me";
    github = "shanemikel";
    githubId = 6720672;
    name = "Shane Pearlman";
  };
  shawndellysse = {
    email = "sdellysse@gmail.com";
    github = "shawndellysse";
    githubId = 293035;
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
    githubId = 1443459;
    name = "Sheena Artrip";
  };
  sheganinans = {
    email = "sheganinans@gmail.com";
    github = "sheganinans";
    githubId = 2146203;
    name = "Aistis Raulinaitis";
  };
  shell = {
    email = "cam.turn@gmail.com";
    github = "VShell";
    githubId = 251028;
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
    githubId = 819413;
    name = "Benedict Aas";
  };
  shyim = {
    email = "s.sayakci@gmail.com";
    github = "shyim";
    githubId = 6224096;
    name = "Soner Sayakci";
  };
  siddharthist = {
    email = "langston.barrett@gmail.com";
    github = "langston-barrett";
    githubId = 4294323;
    name = "Langston Barrett";
  };
  siers = {
    email = "veinbahs+nixpkgs@gmail.com";
    github = "siers";
    githubId = 235147;
    name = "Raitis Veinbahs";
  };
  sifmelcara = {
    email = "ming@culpring.com";
    github = "sifmelcara";
    githubId = 10496191;
    name = "Ming Chuan";
  };
  sigma = {
    email = "yann.hodique@gmail.com";
    github = "sigma";
    githubId = 16090;
    name = "Yann Hodique";
  };
  sikmir = {
    email = "sikmir@gmail.com";
    github = "sikmir";
    githubId = 688044;
    name = "Nikolay Korotkiy";
    keys = [{
      longkeyid = "rsa2048/0xD1DE6D7F693663A5";
      fingerprint = "ADF4 C13D 0E36 1240 BD01  9B51 D1DE 6D7F 6936 63A5";
    }];
  };
  simonchatts = {
    email = "code@chatts.net";
    github = "simonchatts";
    githubId = 11135311;
    name = "Simon Chatterjee";
  };
  simonvandel = {
    email = "simon.vandel@gmail.com";
    github = "simonvandel";
    githubId = 2770647;
    name = "Simon Vandel Sillesen";
  };
  sivteck = {
    email = "sivaram1992@gmail.com";
    github = "sivteck";
    githubId = 8017899;
    name = "Sivaram Balakrishnan";
  };
  sjagoe = {
    email = "simon@simonjagoe.com";
    github = "sjagoe";
    githubId = 80012;
    name = "Simon Jagoe";
  };
  sjau = {
    email = "nixos@sjau.ch";
    github = "sjau";
    githubId = 848812;
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
    githubId = 266500;
    name = "Sven Keidel";
  };
  skrzyp = {
    email = "jot.skrzyp@gmail.com";
    name = "Jakub Skrzypnik";
  };
  sleexyz = {
    email = "freshdried@gmail.com";
    github = "sleexyz";
    githubId = 1505617;
    name = "Sean Lee";
  };
  smakarov = {
    email = "setser200018@gmail.com";
    github = "setser";
    githubId = 12733495;
    name = "Sergey Makarov";
    keys = [{
      longkeyid = "rsa2048/6AA23A1193B7064B";
      fingerprint = "6F8A 18AE 4101 103F 3C54  24B9 6AA2 3A11 93B7 064B";
    }];
  };
  smaret = {
    email = "sebastien.maret@icloud.com";
    github = "smaret";
    githubId = 95471;
    name = "Sébastien Maret";
    keys = [{
      longkeyid = "rsa4096/0x86E30E5A0F5FC59C";
      fingerprint = "4242 834C D401 86EF 8281  4093 86E3 0E5A 0F5F C59C";
    }];
  };
  smironov = {
    email = "grrwlf@gmail.com";
    github = "grwlf";
    githubId = 4477729;
    name = "Sergey Mironov";
  };
  sna = {
    email = "abouzahra.9@wright.edu";
    github = "s-na";
    githubId = 20214715;
    name = "S. Nordin Abouzahra";
  };
  snaar = {
    email = "snaar@snaar.net";
    github = "snaar";
    githubId = 602439;
    name = "Serguei Narojnyi";
  };
  snyh = {
    email = "snyh@snyh.org";
    github = "snyh";
    githubId = 1437166;
    name = "Xia Bin";
  };
  softinio = {
    email = "code@softinio.com";
    github = "softinio";
    githubId = 3371635;
    name = "Salar Rahmanian";
  };
  solson = {
    email = "scott@solson.me";
    github = "solson";
    githubId = 26806;
    name = "Scott Olson";
  };
  sondr3 = {
    email = "nilsen.sondre@gmail.com";
    github = "sondr3";
    githubId = 2280539;
    name = "Sondre Nilsen";
    keys = [{
      longkeyid = "ed25519/0x25676BCBFFAD76B1";
      fingerprint = "0EC3 FA89 EFBA B421 F82E  40B0 2567 6BCB FFAD 76B1";
    }];
  };
  sorki = {
    email = "srk@48.io";
    github = "sorki";
    githubId = 115308;
    name = "Richard Marko";
  };
  sorpaas = {
    email = "hi@that.world";
    github = "sorpaas";
    githubId = 6277322;
    name = "Wei Tang";
  };
  spacefrogg = {
    email = "spacefrogg-nixos@meterriblecrew.net";
    github = "spacefrogg";
    githubId = 167881;
    name = "Michael Raitza";
  };
  spacekookie = {
    email = "kookie@spacekookie.de";
    github = "spacekookie";
    githubId = 7669898;
    name = "Katharina Fey";
  };
  spencerjanssen = {
    email = "spencerjanssen@gmail.com";
    github = "spencerjanssen";
    githubId = 2600039;
    name = "Spencer Janssen";
  };
  spinus = {
    email = "tomasz.czyz@gmail.com";
    github = "spinus";
    githubId = 950799;
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
    githubId = 1414088;
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
    githubId = 8103619;
    name = "SRGOM";
  };
  srhb = {
    email = "sbrofeldt@gmail.com";
    github = "srhb";
    githubId = 219362;
    name = "Sarah Brofeldt";
  };
  SShrike = {
    email = "severen@shrike.me";
    github = "severen";
    githubId = 4061736;
    name = "Severen Redwood";
  };
  steell = {
    email = "steve@steellworks.com";
    github = "Steell";
    githubId = 1699155;
    name = "Steve Elliott";
  };
  stephenmw = {
    email = "stephen@q5comm.com";
    github = "stephenmw";
    githubId = 231788;
    name = "Stephen Weinberg";
  };
  sterfield = {
    email = "sterfield@gmail.com";
    github = "sterfield";
    githubId = 5747061;
    name = "Guillaume Loetscher";
  };
  sternenseemann = {
    email = "post@lukasepple.de";
    github = "sternenseemann";
    githubId = 3154475;
    name = "Lukas Epple";
  };
  steshaw = {
    name = "Steven Shaw";
    email = "steven@steshaw.org";
    github = "steshaw";
    githubId = 45735;
    keys = [{
      longkeyid = "rsa4096/0x1D9A17DFD23DCB91";
      fingerprint = "0AFE 77F7 474D 1596 EE55  7A29 1D9A 17DF D23D CB91";
    }];
  };
  stesie = {
    email = "stesie@brokenpipe.de";
    github = "stesie";
    githubId = 113068;
    name = "Stefan Siegl";
  };
  steve-chavez = {
    email = "stevechavezast@gmail.com";
    github = "steve-chavez";
    githubId = 1829294;
    name = "Steve Chávez";
  };
  steveej = {
    email = "mail@stefanjunker.de";
    github = "steveej";
    githubId = 1181362;
    name = "Stefan Junker";
  };
  StijnDW = {
    email = "stekke@airmail.cc";
    github = "StijnDW";
    githubId = 1751956;
    name = "Stijn DW";
  };
  StillerHarpo = {
    email = "florianengel39@gmail.com";
    github = "StillerHarpo";
    githubId = 25526706;
    name = "Florian Engel";
  };
  stites = {
    email = "sam@stites.io";
    github = "stites";
    githubId = 1694705;
    name = "Sam Stites";
  };
  stumoss = {
    email = "samoss@gmail.com";
    github = "stumoss";
    githubId = 638763;
    name = "Stuart Moss";
  };
  suhr = {
    email = "suhr@i2pmail.org";
    github = "suhr";
    githubId = 65870;
    name = "Сухарик";
  };
  SuprDewd = {
    email = "suprdewd@gmail.com";
    github = "SuprDewd";
    githubId = 187109;
    name = "Bjarki Ágúst Guðmundsson";
  };
  suvash = {
    email = "suvash+nixpkgs@gmail.com";
    github = "suvash";
    githubId = 144952;
    name = "Suvash Thapaliya";
  };
  sveitser = {
    email = "sveitser@gmail.com";
    github = "sveitser";
    githubId = 1040871;
    name = "Mathis Antony";
  };
  svsdep = {
    email = "svsdep@gmail.com";
    github = "svsdep";
    githubId = 36695359;
    name = "Vasyl Solovei";
  };
  swarren83 = {
    email = "shawn.w.warren@gmail.com";
    github = "swarren83";
    githubId = 4572854;
    name = "Shawn Warren";
  };
  swdunlop = {
    email = "swdunlop@gmail.com";
    github = "swdunlop";
    githubId = 120188;
    name = "Scott W. Dunlop";
  };
  sweber = {
    email = "sweber2342+nixpkgs@gmail.com";
    github = "sweber83";
    githubId = 19905904;
    name = "Simon Weber";
  };
  swflint = {
    email = "swflint@flintfam.org";
    github = "swflint";
    githubId = 1771109;
    name = "Samuel W. Flint";
  };
  swistak35 = {
    email = "me@swistak35.com";
    github = "swistak35";
    githubId = 332289;
    name = "Rafał Łasocha";
  };
  symphorien = {
    email = "symphorien_nixpkgs@xlumurb.eu";
    github = "symphorien";
    githubId = 12595971;
    name = "Guillaume Girol";
  };
  synthetica = {
    email = "nix@hilhorst.be";
    github = "Synthetica9";
    githubId = 7075751;
    name = "Patrick Hilhorst";
  };
  szczyp = {
    email = "qb@szczyp.com";
    github = "szczyp";
    githubId = 203195;
    name = "Szczyp";
  };
  sztupi = {
    email = "attila.sztupak@gmail.com";
    github = "sztupi";
    githubId = 143103;
    name = "Attila Sztupak";
  };
  t184256 = {
    email = "monk@unboiled.info";
    github = "t184256";
    githubId = 5991987;
    name = "Alexander Sosedkin";
  };
  tadeokondrak = {
    email = "me@tadeo.ca";
    github = "tadeokondrak";
    githubId = 4098453;
    name = "Tadeo Kondrak";
    keys = [{
      longkeyid = "ed25519/0xFBE607FCC49516D3";
      fingerprint = "0F2B C0C7 E77C 5B42 AC5B  4C18 FBE6 07FC C495 16D3";
    }];
  };
  tadfisher = {
    email = "tadfisher@gmail.com";
    github = "tadfisher";
    githubId = 129148;
    name = "Tad Fisher";
  };
  taeer = {
    email = "taeer@necsi.edu";
    github = "Radvendii";
    githubId = 1239929;
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
    githubId = 321799;
    name = "Paul Colomiets";
  };
  taketwo = {
    email = "alexandrov88@gmail.com";
    github = "taketwo";
    githubId = 1241736;
    name = "Sergey Alexandrov";
  };
  takikawa = {
    email = "asumu@igalia.com";
    github = "takikawa";
    githubId = 64192;
    name = "Asumu Takikawa";
  };
  taktoa = {
    email = "taktoa@gmail.com";
    github = "taktoa";
    githubId = 553443;
    name = "Remy Goldschmidt";
  };
  taku0 = {
    email = "mxxouy6x3m_github@tatapa.org";
    github = "taku0";
    githubId = 870673;
    name = "Takuo Yonezawa";
  };
  talyz = {
    email = "kim.lindberger@gmail.com";
    github = "talyz";
    githubId = 63433;
    name = "Kim Lindberger";
  };
  taneb = {
    email = "nvd1234@gmail.com";
    github = "Taneb";
    githubId = 1901799;
    name = "Nathan van Doorn";
  };
  tari = {
    email = "peter@taricorp.net";
    github = "tari";
    githubId = 506181;
    name = "Peter Marheine";
  };
  tasmo = {
    email = "tasmo@tasmo.de";
    github = "tasmo";
    githubId = 102685;
    name = "Thomas Friese";
  };
  tavyc = {
    email = "octavian.cerna@gmail.com";
    github = "tavyc";
    githubId = 3650609;
    name = "Octavian Cerna";
  };
  tazjin = {
    email = "mail@tazj.in";
    github = "tazjin";
    githubId = 1552853;
    name = "Vincent Ambo";
  };
  tbenst = {
    email = "nix@tylerbenster.com";
    github = "tbenst";
    githubId = 863327;
    name = "Tyler Benster";
  };
  tckmn = {
    email = "andy@tck.mn";
    github = "tckmn";
    name = "Andy Tockman";
  };
  teh = {
    email = "tehunger@gmail.com";
    github = "teh";
    githubId = 139251;
    name = "Tom Hunger";
  };
  telotortium = {
    email = "rirelan@gmail.com";
    github = "telotortium";
    githubId = 1755789;
    name = "Robert Irelan";
  };
  teozkr = {
    email = "teo@nullable.se";
    github = "teozkr";
    githubId = 649832;
    name = "Teo Klestrup Röijezon";
  };
  terlar = {
    email = "terlar@gmail.com";
    github = "terlar";
    githubId = 280235;
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
    githubId = 27386;
    name = "Milan Svoboda";
  };
  tg-x = {
    email = "*@tg-x.net";
    github = "tg-x";
    githubId = 378734;
    name = "TG ⊗ Θ";
  };
  thall = {
    email = "niclas.thall@gmail.com";
    github = "thall";
    githubId = 102452;
    name = "Niclas Thall";
  };
  thammers = {
    email = "jawr@gmx.de";
    github = "tobias-hammerschmidt";
    githubId = 2543259;
    name = "Tobias Hammerschmidt";
  };
  thanegill = {
    email = "me@thanegill.com";
    github = "thanegill";
    githubId = 1141680;
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
    githubId = 629710;
    name = "David Meister";
  };
  thefloweringash = {
    email = "lorne@cons.org.nz";
    github = "thefloweringash";
    githubId = 42933;
    name = "Andrew Childs";
  };
  thefenriswolf = {
    email = "stefan.rohrbacher97@gmail.com";
    github = "thefenriswolf";
    githubId = 8547242;
    name = "Stefan Rohrbacher";
  };
  thesola10 = {
    email = "thesola10@bobile.fr";
    github = "thesola10";
    githubId = 7287268;
    keys = [{
      longkeyid = "rsa4096/0x89245619BEBB95BA";
      fingerprint = "1D05 13A6 1AC4 0D8D C6D6  5F2C 8924 5619 BEBB 95BA";
    }];
    name = "Karim Vergnes";
  };
  theuni = {
    email = "ct@flyingcircus.io";
    github = "ctheune";
    githubId = 1220572;
    name = "Christian Theune";
  };
  thiagokokada = {
    email = "thiagokokada@gmail.com";
    github = "thiagokokada";
    githubId = 844343;
    name = "Thiago K. Okada";
  };
  ThomasMader = {
    email = "thomas.mader@gmail.com";
    github = "ThomasMader";
    githubId = 678511;
    name = "Thomas Mader";
  };
  thoughtpolice = {
    email = "aseipp@pobox.com";
    github = "thoughtpolice";
    githubId = 3416;
    name = "Austin Seipp";
  };
  thpham = {
    email = "thomas.pham@ithings.ch";
    github = "thpham";
    githubId = 224674;
    name = "Thomas Pham";
  };
  Thra11 = {
    email = "tahall256@protonmail.ch";
    github = "Thra11";
    githubId = 1391883;
    name = "Tom Hall";
  };
  tilpner = {
    email = "till@hoeppner.ws";
    github = "tilpner";
    githubId = 4322055;
    name = "Till Höppner";
  };
  timbertson = {
    email = "tim@gfxmonk.net";
    github = "timbertson";
    name = "Tim Cuthbertson";
  };
  timma = {
    email = "kunduru.it.iitb@gmail.com";
    github = "ktrsoft";
    name = "Timma";
  };
  timokau = {
    email = "timokau@zoho.com";
    github = "timokau";
    githubId = 3799330;
    name = "Timo Kaufmann";
  };
  timor = {
    email = "timor.dd@googlemail.com";
    github = "timor";
    githubId = 174156;
    name = "timor";
  };
  timput = {
    email = "tim@timput.com";
    github = "TimPut";
    githubId = 2845239;
    name = "Tim Put";
  };
  tiramiseb = {
    email = "sebastien@maccagnoni.eu";
    github = "tiramiseb";
    githubId = 1292007;
    name = "Sébastien Maccagnoni";
  };
  titanous = {
    email = "jonathan@titanous.com";
    github = "titanous";
    githubId = 13026;
    name = "Jonathan Rudenberg";
  };
  tkerber = {
    email = "tk@drwx.org";
    github = "tkerber";
    githubId = 5722198;
    name = "Thomas Kerber";
    keys = [ {
      longkeyid = "rsa4096/0x8489B911F9ED617B";
      fingerprint = "556A 403F B0A2 D423 F656  3424 8489 B911 F9ED 617B";
    } ];
  };
  tmplt = {
    email = "tmplt@dragons.rocks";
    github = "tmplt";
    githubId = 6118602;
    name = "Viktor";
  };
  tnias = {
    email = "phil@grmr.de";
    github = "tnias";
    name = "Philipp Bartsch";
  };
  tobim = {
    email = "nix@tobim.fastmail.fm";
    github = "tobim";
    githubId = 858790;
    name = "Tobias Mayer";
  };
  tobiasBora = {
    email = "tobias.bora.list@gmail.com";
    github = "tobiasBora";
    githubId = 2164118;
    name = "Tobias Bora";
  };
  tohl = {
    email = "tom@logand.com";
    github = "tohl";
    githubId = 12159013;
    name = "Tomas Hlavaty";
  };
  tokudan = {
    email = "git@danielfrank.net";
    github = "tokudan";
    githubId = 692610;
    name = "Daniel Frank";
  };
  tomahna = {
    email = "kevin.rauscher@tomahna.fr";
    github = "Tomahna";
    githubId = 8577941;
    name = "Kevin Rauscher";
  };
  tomberek = {
    email = "tomberek@gmail.com";
    github = "tomberek";
    githubId = 178444;
    name = "Thomas Bereknyei";
  };
  tomfitzhenry = {
    email = "tom@tom-fitzhenry.me.uk";
    github = "tomfitzhenry";
    githubId = 61303;
    name = "Tom Fitzhenry";
  };
  tomsmeets = {
    email = "tom.tsmeets@gmail.com";
    github = "tomsmeets";
    githubId = 6740669;
    name = "Tom Smeets";
  };
  toonn = {
    email = "nnoot@toonn.io";
    github = "toonn";
    githubId = 1486805;
    name = "Toon Nolten";
  };
  travisbhartwell = {
    email = "nafai@travishartwell.net";
    github = "travisbhartwell";
    githubId = 10110;
    name = "Travis B. Hartwell";
  };
  treemo = {
    email = "matthieu.chevrier@treemo.fr";
    github = "treemo";
    githubId = 207457;
    name = "Matthieu Chevrier";
  };
  trevorj = {
    email = "nix@trevor.joynson.io";
    github = "akatrevorjay";
    githubId = 1312290;
    name = "Trevor Joynson";
  };
  tricktron = {
    email = "tgagnaux@gmail.com";
    github = "tricktron";
    githubId = 16036882;
    name = "Thibault Gagnaux";
  };
  trino = {
    email = "muehlhans.hubert@ekodia.de";
    github = "hmuehlhans";
    githubId = 9870613;
    name = "Hubert Mühlhans";
  };
  troydm = {
    email = "d.geurkov@gmail.com";
    github = "troydm";
    githubId = 483735;
    name = "Dmitry Geurkov";
  };
  tscholak = {
    email = "torsten.scholak@googlemail.com";
    github = "tscholak";
    name = "Torsten Scholak";
  };
  tstrobel = {
    email = "4ZKTUB6TEP74PYJOPWIR013S2AV29YUBW5F9ZH2F4D5UMJUJ6S@hash.domains";
    name = "Thomas Strobel";
  };
  ttuegel = {
    email = "ttuegel@mailbox.org";
    github = "ttuegel";
    githubId = 563054;
    name = "Thomas Tuegel";
  };
  tv = {
    email = "tv@krebsco.de";
    github = "4z3";
    githubId = 427872;
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
    githubId = 1325161;
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
  twhitehead = {
    name = "Tyson Whitehead";
    email = "twhitehead@gmail.com";
    github = "twhitehead";
    githubId = 787843;
    keys = [{
      longkeyid = "rsa2048/0x594258F0389D2802";
      fingerprint = "E631 8869 586F 99B4 F6E6  D785 5942 58F0 389D 2802";
    }];
  };
  typetetris = {
    email = "ericwolf42@mail.com";
    github = "typetetris";
    githubId = 1983821;
    name = "Eric Wolf";
  };
  udono = {
    email = "udono@virtual-things.biz";
    github = "udono";
    githubId = 347983;
    name = "Udo Spallek";
  };
  unode = {
    email = "alves.rjc@gmail.com";
    github = "unode";
    githubId = 122319;
    name = "Renato Alves";
  };
  uralbash = {
    email = "root@uralbash.ru";
    github = "uralbash";
    githubId = 619015;
    name = "Svintsov Dmitry";
  };
  uri-canva = {
    email = "uri@canva.com";
    github = "uri-canva";
    githubId = 33242106;
    name = "Uri Baghin";
  };
  uskudnik = {
    email = "urban.skudnik@gmail.com";
    github = "uskudnik";
    githubId = 120451;
    name = "Urban Skudnik";
  };
  utdemir = {
    email = "me@utdemir.com";
    github = "utdemir";
    githubId = 928084;
    name = "Utku Demir";
  };
  uvnikita = {
    email = "uv.nikita@gmail.com";
    github = "uvNikita";
    githubId = 1084748;
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
    githubId = 31535155;
    name = "Valentin Heidelberger";
  };
  vaibhavsagar = {
    email = "vaibhavsagar@gmail.com";
    github = "vaibhavsagar";
    githubId = 1525767;
    name = "Vaibhav Sagar";
  };
  valebes = {
    email = "valebes@gmail.com";
    github = "valebes";
    githubid = 10956211;
    name = "Valerio Besozzi";
  };
  valeriangalliat = {
    email = "val@codejam.info";
    github = "valeriangalliat";
    name = "Valérian Galliat";
  };
  vandenoever = {
    email = "jos@vandenoever.info";
    github = "vandenoever";
    githubId = 608417;
    name = "Jos van den Oever";
  };
  vanschelven = {
    email = "klaas@vanschelven.com";
    github = "vanschelven";
    githubId = 223833;
    name = "Klaas van Schelven";
  };
  vanzef = {
    email = "vanzef@gmail.com";
    github = "vanzef";
    githubId = 12428837;
    name = "Ivan Solyankin";
  };
  varunpatro = {
    email = "varun.kumar.patro@gmail.com";
    github = "varunpatro";
    githubId = 6943308;
    name = "Varun Patro";
  };
  vbgl = {
    email = "Vincent.Laporte@gmail.com";
    github = "vbgl";
    githubId = 2612464;
    name = "Vincent Laporte";
  };
  vbmithr = {
    email = "vb@luminar.eu.org";
    github = "vbmithr";
    githubId = 797581;
    name = "Vincent Bernardoff";
  };
  vcanadi = {
    email = "vito.canadi@gmail.com";
    github = "vcanadi";
    name = "Vitomir Čanadi";
  };
  vcunat = {
    name = "Vladimír Čunát";
    email = "v@cunat.cz"; # vcunat@gmail.com predominated in commits before 2019/03
    github = "vcunat";
    githubId = 1785925;
    keys = [{
      longkeyid = "rsa4096/0xE747DF1F9575A3AA";
      fingerprint = "B600 6460 B60A 80E7 8206  2449 E747 DF1F 9575 A3AA";
    }];
  };
  vdemeester = {
    email = "vincent@sbr.pm";
    github = "vdemeester";
    githubId = 6508;
    name = "Vincent Demeester";
  };
  velovix = {
    email = "xaviosx@gmail.com";
    github = "velovix";
    githubId = 2856634;
    name = "Tyler Compton";
  };
  veprbl = {
    email = "veprbl@gmail.com";
    github = "veprbl";
    githubId = 245573;
    name = "Dmitry Kalinkin";
  };
  vidbina = {
    email = "vid@bina.me";
    github = "vidbina";
    githubId = 335406;
    name = "David Asabina";
  };
  vifino = {
    email = "vifino@tty.sh";
    github = "vifino";
    githubId = 5837359;
    name = "Adrian Pistol";
  };
  vika_nezrimaya = {
    email = "vika@fireburn.ru";
    github = "kisik21";
    githubId = 7953163;
    name = "Vika Shleina";
    keys = [{
      longkeyid = "rsa4096/0x5402B9B5497BACDB";
      fingerprint = "A03C D09C 36CF D9F6 1ADF  AF11 5402 B9B5 497B ACDB";
    }];
  };
  vinymeuh = {
    email = "vinymeuh@gmail.com";
    github = "vinymeuh";
    githubId = 118959;
    name = "VinyMeuh";
  };
  viric = {
    email = "viric@viric.name";
    github = "viric";
    name = "Lluís Batlle i Rossell";
  };
  virusdave = {
    email = "dave.nicponski@gmail.com";
    github = "virusdave";
    githubId = 6148271;
    name = "Dave Nicponski";
  };
  vizanto = {
    email = "danny@prime.vc";
    github = "vizanto";
    name = "Danny Wilson";
  };
  vklquevs = {
    email = "vklquevs@gmail.com";
    github = "vklquevs";
    githubId = 1771234;
    name = "vklquevs";
  };
  vlaci = {
    email = "laszlo.vasko@outlook.com";
    github = "vlaci";
    githubId = 1771332;
    name = "László Vaskó";
  };
  vlstill = {
    email = "xstill@fi.muni.cz";
    github = "vlstill";
    githubId = 4070422;
    name = "Vladimír Štill";
  };
  vmandela = {
    email = "venkat.mandela@gmail.com";
    github = "vmandela";
    githubId = 849772;
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
    githubId = 5604643;
    name = "Mikhail Volkhov";
  };
  volth = {
    email = "jaroslavas@volth.com";
    github = "volth";
    githubId = 508305;
    name = "Jaroslavas Pocepko";
  };
  vozz = {
    email = "oliver.huntuk@gmail.com";
    name = "Oliver Hunt";
  };
  vrthra = {
    email = "rahul@gopinath.org";
    github = "vrthra";
    githubId = 70410;
    name = "Rahul Gopinath";
  };
  vskilet = {
    email = "victor@sene.ovh";
    github = "vskilet";
    githubId = 7677567;
    name = "Victor SENE";
  };
  vyorkin = {
    email = "vasiliy.yorkin@gmail.com";
    github = "vyorkin";
    githubId = 988849;
    name = "Vasiliy Yorkin";
  };
  vyp = {
    email = "elisp.vim@gmail.com";
    github = "vyp";
    githubId = 3889405;
    name = "vyp";
  };
  waynr = {
    name = "Wayne Warren";
    email = "wayne.warren.s@gmail.com";
    github = "waynr";
    githubId = 1441126;
  };
  wchresta = {
    email = "wchresta.nix@chrummibei.ch";
    github = "wchresta";
    githubId = 34962284;
    name = "wchresta";
  };
  wedens = {
    email = "kirill.wedens@gmail.com";
    name = "wedens";
  };
  WhittlesJr = {
    email = "alex.joseph.whitt@gmail.com";
    github = "WhittlesJr";
    githubId = 19174984;
    name = "Alex Whitt";
  };
  willibutz = {
    email = "willibutz@posteo.de";
    github = "willibutz";
    githubId = 20464732;
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
    githubId = 6016963;
    name = "Patrick Winter";
  };
  wizeman = {
    email = "rcorreia@wizy.org";
    github = "wizeman";
    githubId = 168610;
    name = "Ricardo M. Correia";
  };
  wjlroe = {
    email = "willroe@gmail.com";
    github = "wjlroe";
    githubId = 43315;
    name = "William Roe";
  };
  wmertens = {
    email = "Wout.Mertens@gmail.com";
    github = "wmertens";
    githubId = 54934;
    name = "Wout Mertens";
  };
  woffs = {
    email = "github@woffs.de";
    github = "woffs";
    githubId = 895853;
    name = "Frank Doepper";
  };
  womfoo = {
    email = "kranium@gikos.net";
    github = "womfoo";
    githubId = 1595132;
    name = "Kranium Gikos Mendoza";
  };
  worldofpeace = {
    email = "worldofpeace@protonmail.ch";
    github = "worldofpeace";
    githubId = 28888242;
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
    githubId = 20400405;
    name = "Wucke";
  };
  wykurz = {
    email = "wykurz@gmail.com";
    github = "wykurz";
    githubId = 483465;
    name = "Mateusz Wykurz";
  };
  wyvie = {
    email = "elijahrum@gmail.com";
    github = "wyvie";
    githubId = 3992240;
    name = "Elijah Rum";
  };
  xaverdh = {
    email = "hoe.dom@gmx.de";
    github = "xaverdh";
    githubId = 11050617;
    name = "Dominik Xaver Hörl";
  };
  xbreak = {
    email = "xbreak@alphaware.se";
    github = "xbreak";
    githubId = 13489144;
    name = "Calle Rosenquist";
  };
  xeji = {
    email = "xeji@cat3.de";
    github = "xeji";
    githubId = 36407913;
    name = "Uli Baum";
  };
  xfix = {
    email = "konrad@borowski.pw";
    github = "xfix";
    githubId = 1297598;
    name = "Konrad Borowski";
  };
  xnaveira = {
    email = "xnaveira@gmail.com";
    github = "xnaveira";
    name = "Xavier Naveira";
  };
  xnwdd = {
    email = "nwdd+nixos@no.team";
    github = "xnwdd";
    githubId = 3028542;
    name = "Guillermo NWDD";
  };
  xrelkd = {
    email = "46590321+xrelkd@users.noreply.github.com";
    github = "xrelkd";
    githubId = 46590321;
    name = "xrelkd";
  };
  xurei = {
    email = "olivier.bourdoux@gmail.com";
    github = "xurei";
    githubId = 621695;
    name = "Olivier Bourdoux";
  };
  xvapx = {
    email = "marti.serra.coscollano@gmail.com";
    github = "xvapx";
    githubId = 11824817;
    name = "Marti Serra";
  };
  xwvvvvwx = {
    email = "davidterry@posteo.de";
    github = "xwvvvvwx";
    githubId = 6689924;
    name = "David Terry";
  };
  xzfc = {
    email = "xzfcpw@gmail.com";
    github = "xzfc";
    githubId = 5121426;
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
    githubId = 41838844;
    name = "Yarny";
  };
  yarr = {
    email = "savraz@gmail.com";
    github = "Eternity-Yarr";
    githubId = 3705333;
    name = "Dmitry V.";
  };
  yegortimoshenko = {
    email = "yegortimoshenko@riseup.net";
    github = "yegortimoshenko";
    githubId = 1643293;
    name = "Yegor Timoshenko";
  };
  yesbox = {
    email = "jesper.geertsen.jonsson@gmail.com";
    github = "yesbox";
    githubId = 4113027;
    name = "Jesper Geertsen Jonsson";
  };
  ylwghst = {
    email = "ylwghst@onionmail.info";
    github = "ylwghst";
    githubId = 26011724;
    name = "Burim Augustin Berisa";
  };
  yochai = {
    email = "yochai@titat.info";
    github = "yochai";
    githubId = 1322201;
    name = "Yochai";
  };
  yorickvp = {
    email = "yorickvanpelt@gmail.com";
    github = "yorickvp";
    githubId = 647076;
    name = "Yorick van Pelt";
  };
  yrashk = {
    email = "yrashk@gmail.com";
    github = "yrashk";
    githubId = 452;
    name = "Yurii Rashkovskii";
  };
  ysndr = {
    email = "me@ysndr.de";
    github = "ysndr";
    githubId = 7040031;
    name = "Yannik Sander";
  };
  yuriaisaka = {
    email = "yuri.aisaka+nix@gmail.com";
    github = "yuriaisaka";
    githubId = 687198;
    name = "Yuri Aisaka";
  };
  yurrriq = {
    email = "eric@ericb.me";
    github = "yurrriq";
    githubId = 1866448;
    name = "Eric Bailey";
  };
  Yumasi = {
    email = "gpagnoux@gmail.com";
    github = "Yumasi";
    githubId = 24368641;
    name = "Guillaume Pagnoux";
    keys = [{
      longkeyid = "rsa4096/0xEC5065899AEAAF4C";
      fingerprint = "85F8 E850 F8F2 F823 F934  535B EC50 6589 9AEA AF4C";
    }];
  };
  yvt = {
    email = "i@yvt.jp";
    github = "yvt";
    githubId = 5253988;
    name = "yvt";
  };
  maggesi = {
    email = "marco.maggesi@gmail.com";
    github = "maggesi";
    githubId = 1809783;
    name = "Marco Maggesi";
  };
  zachcoyle = {
    email = "zach.coyle@gmail.com";
    github = "zachcoyle";
    githubId = 908716;
    name = "Zach Coyle";
  };
  zagy = {
    email = "cz@flyingcircus.io";
    github = "zagy";
    githubId = 568532;
    name = "Christian Zagrodnick";
  };
  zalakain = {
    email = "ping@umazalakain.info";
    github = "umazalakain";
    name = "Uma Zalakain";
  };
  zaninime = {
    email = "francesco@zanini.me";
    github = "zaninime";
    githubId = 450885;
    name = "Francesco Zanini";
  };
  zarelit = {
    email = "david@zarel.net";
    github = "zarelit";
    githubId = 3449926;
    name = "David Costa";
  };
  zauberpony = {
    email = "elmar@athmer.org";
    github = "zauberpony";
    githubId = 250877;
    name = "Elmar Athmer";
  };
  zef = {
    email = "zef@zef.me";
    name = "Zef Hemel";
  };
  zfnmxt = {
    name = "zfnmxt";
    email = "zfnmxt@zfnmxt.com";
    github = "zfnmxt";
    githubId = 37446532;
  };
  zgrannan = {
    email = "zgrannan@gmail.com";
    github = "zgrannan";
    githubId = 1141948;
    name = "Zack Grannan";
  };
  zimbatm = {
    email = "zimbatm@zimbatm.com";
    github = "zimbatm";
    githubId = 3248;
    name = "zimbatm";
  };
  Zimmi48 = {
    email = "theo.zimmermann@univ-paris-diderot.fr";
    github = "Zimmi48";
    githubId = 1108325;
    name = "Théo Zimmermann";
  };
  zohl = {
    email = "zohl@fmap.me";
    github = "zohl";
    githubId = 6067895;
    name = "Al Zohali";
  };
  zookatron = {
    email = "tim@zookatron.com";
    github = "zookatron";
    githubId = 1772064;
    name = "Tim Zook";
  };
  zoomulator = {
    email = "zoomulator@gmail.com";
    github = "zoomulator";
    githubId = 1069303;
    name = "Kim Simmons";
  };
  zraexy = {
    email = "zraexy@gmail.com";
    github = "zraexy";
    githubId = 8100652;
    name = "David Mell";
  };
  zx2c4 = {
    email = "Jason@zx2c4.com";
    github = "zx2c4";
    githubId = 10643;
    name = "Jason A. Donenfeld";
  };
  zzamboni = {
    email = "diego@zzamboni.org";
    github = "zzamboni";
    githubId = 32876;
    name = "Diego Zamboni";
  };
  turbomack = {
    email = "marek.faj@gmail.com";
    github = "turboMaCk";
    githubId = 2130305;
    name = "Marek Fajkus";
  };
  melling = {
    email = "mattmelling@fastmail.com";
    github = "mattmelling";
    githubId = 1215331;
    name = "Matt Melling";
  };
  wd15 = {
    email = "daniel.wheeler2@gmail.com";
    github = "wd15";
    githubId = 1986844;
    name = "Daniel Wheeler";
  };
  misuzu = {
    email = "bakalolka@gmail.com";
    github = "misuzu";
    githubId = 248143;
    name = "misuzu";
  };
  zokrezyl = {
    email = "zokrezyl@gmail.com";
    github = "zokrezyl";
    githubId = 51886259;
    name = "Zokre Zyl";
  };
  rakesh4g = {
    email = "rakeshgupta4u@gmail.com";
    github = "rakesh4g";
    githubId = 50867187;
    name = "Rakesh Gupta";
  };
  mlatus = {
    email = "wqseleven@gmail.com";
    github = "Ninlives";
    githubId = 17873203;
    name = "mlatus";
  };
  waiting-for-dev = {
    email = "marc@lamarciana.com";
    github = "waiting-for-dev";
    githubId = 52650;
    name = "Marc Busqué";
  };
  snglth = {
    email = "illia@ishestakov.com";
    github = "snglth";
    githubId = 8686360;
    name = "Illia Shestakov";
  };
}
