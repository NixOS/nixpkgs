const path = require('path')

const urlToName = url => {
  const isCodeloadGitTarballUrl = url.startsWith('https://codeload.github.com/') && url.includes('/tar.gz/')

  if (url.startsWith('file:')) {
    return url
  } else if (url.startsWith('git+') || isCodeloadGitTarballUrl) {
    return path.basename(url)
  } else {
    return url
      .replace(/https:\/\/(.)*(.com)\//g, '') // prevents having long directory names
      .replace(/[@/%:-]/g, '_') // replace @ and : and - and % characters with underscore
  }
}

module.exports = { urlToName };
