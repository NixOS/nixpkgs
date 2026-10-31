{
  runCommand,
  writeText,
  nodejs,
  n8n-nodes-carbonejs,
}:

let
  withLibreOffice = n8n-nodes-carbonejs.override { withLibreOffice = true; };

  convert = writeText "convert.js" ''
    const carbone = require("${withLibreOffice}/lib/node_modules/n8n-nodes-carbonejs/node_modules/carbone");
    const html = Buffer.from("<html><body><h1>carbone</h1></body></html>");
    carbone.convert(html, { extension: "html", convertTo: "pdf" }, (err, pdf) => {
      if (err) {
        console.error("conversion failed:", err.message || err);
        process.exit(1);
      }
      const magic = pdf.subarray(0, 5).toString();
      if (magic !== "%PDF-") {
        console.error("not a PDF, got " + JSON.stringify(magic));
        process.exit(1);
      }
      console.log("converted html to a " + pdf.length + " byte PDF");
      process.exit(0);
    });
  '';
in
runCommand "n8n-nodes-carbonejs-pdf-conversion"
  {
    nativeBuildInputs = [ nodejs ];
  }
  ''
    export HOME="$TMPDIR"
    node ${convert}
    touch $out
  ''
