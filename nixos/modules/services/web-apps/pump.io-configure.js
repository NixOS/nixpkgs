var fs = require('fs');

var opts = JSON.parse(fs.readFileSync("/dev/stdin").toString());
var config = opts.config;

var readSecret = function(filename) {
  return fs.readFileSync(filename).toString().trim();
};

if (opts.secretFile) {
  config.secret = readSecret(opts.secretFile);
}
if (opts.dbPasswordFile) {
  config.params.dbpass = readSecret(opts.dbPasswordFile);
}
if (opts.smtpPasswordFile) {
  config.smtppass = readSecret(opts.smtpPasswordFile);
}
if (opts.spamClientSecretFile) {
  config.spamclientsecret = readSecret(opts.opts.spamClientSecretFile);
}

fs.writeFileSync(opts.outputFile, JSON.stringify(config));
