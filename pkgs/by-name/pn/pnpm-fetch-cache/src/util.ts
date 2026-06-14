export const urlToCachePath = (url: string | URL) => {
	if (!(url instanceof URL)) {
		url = new URL(url)
	}

	// url.protocol includes the colon. We just need the scheme name
	const scheme = url.protocol.substring(0, url.protocol.length - 1)

	return `${scheme}/${url.hostname}${url.pathname}`
}
