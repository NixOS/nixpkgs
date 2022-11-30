#V1: {
	init:           string
	initrd?:        string
	initrdSecrets?: string
	kernel:         string
	kernelParams: [...string]
	label:    string
	toplevel: string
	specialisation?: {
		[=~"^"]: #V1
	}
	extensions?: {...}
}

#SecureBootExtensions: #V1 & {
	extensions: {
		osRelease: string
	}
}

Document: {
	v1: #V1
}
