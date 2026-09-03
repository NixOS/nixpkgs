import os

#############################################
# Django settings for Fidus Writer project. #
#############################################

# After copying this file to configuration.py, adjust the below settings to
# work with your setup.

# If you don't want to show debug messages, set DEBUG to False.

DEBUG = True
# SOURCE_MAPS - allows any value used by webpack devtool
# https://webpack.js.org/configuration/devtool/
# For example
# SOURCE_MAPS = 'cheap-module-source-map' # fast - line numbers only
# SOURCE_MAPS = 'source-map' # slow - line and column number
SOURCE_MAPS = False

PROJECT_PATH = os.environ.get("PROJECT_PATH")
# SRC_PATH is the root path of the FW sources.
SRC_PATH = os.environ.get("SRC_PATH")

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "fiduswriter",
        "USER": "fiduswriter",
        "PASSWORD": "password",
        "HOST": "localhost",
        "PORT": "5432",
    }
}

# Interval between document saves
# DOC_SAVE_INTERVAL = 1

# Migrate, transpile JavaScript and install required fixtures automatically
# when starting runserver. You might want to turn this off on a production
# server. The default is the opposite of DEBUG

# AUTO_SETUP = False

# This determines whether the server is used for testing and will let the
# users know upon signup know that their documents may disappear.
TEST_SERVER = True
# This is the contact email that will be shown in various places all over
# the site.
CONTACT_EMAIL = "mail@email.com"
# Ports that Fidus Writer will run on.
PORTS = [4386]

# Ports this server instance actually binds to. Defaults to PORTS.
# For multi-server setups, set this to only the port(s) served locally.
# LOCAL_PORTS = [4386]

# ProseMirror backend used by the document WebSocket consumer.
# "python" - pure-Python prosemirror package (default).
# "rust"   - prosemirror-rs Rust extension (requires `pip install prosemirror-rs`). EXPERIMENTAL
#            Keeps document state in Rust memory; avoids Python object tree overhead.
PROSEMIRROR_BACKEND = "python"

# Allow the server to listen to all network interfaces (0.0.0.0) instead of just localhost
# SECURITY WARNING: Setting this to True in production environments could expose your server
LISTEN_TO_ALL_INTERFACES = False

ADMINS = (("Your Name", "your_email@example.com"),)

# Whether anyone surfing to the site can open an account with a login/password.
REGISTRATION_OPEN = True

# Whether user's can login using passwords (if not, they will only be able to
# sign in using social accounts).
PASSWORD_LOGIN = True

# Whether anyone surfing to the site can open an account or login with a
# socialaccount.
SOCIALACCOUNT_OPEN = True

# ACCOUNT_EMAIL_VERIFICATION = 'optional'

# This determines whether there is a star labeled "Free" on the login page
IS_FREE = True

MANAGERS = ADMINS

# DATABASES = {
#    'default': {
# Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
#        'ENGINE': 'django.db.backends.',
# Or path to database file if using sqlite3.
#        'NAME': '',
# Not used with sqlite3.
#        'USER': '',
# Not used with sqlite3.
#        'PASSWORD': '',
# Set to empty string for localhost. Not used with sqlite3.
#        'HOST': '',
# Set to empty string for default. Not used with sqlite3.
#        'PORT': '',
# The max time in seconds a database connection should wait for a subsequent
# request.
#        'CONN_MAX_AGE': 15
#    }
# }

# Send emails using an SMTP server
# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
# EMAIL_HOST = 'localhost'
# EMAIL_HOST_USER = ''
# EMAIL_HOST_PASSWORD = ''
# EMAIL_PORT = 25
# EMAIL_SUBJECT_PREFIX = '[Fidus Writer]'
# EMAIL_USE_TLS = False
# DEFAULT_FROM_EMAIL = 'mail@email.com' # For messages to end users
# SERVER_EMAIL = 'mail@email.com' # For messages to server administrators

# FOOTER_LINKS = [
#     {
#         "text": "Terms and Conditions",
#         "link": "/pages/terms/"
#     },
#     {
#         "text": "Privacy policy",
#         "link": "/pages/privacy/"
#     },
#     {
#         "text": "Equations and Math with MathLive",
#         "link": "https://github.com/arnog/mathlive#readme",
#         "external": True
#     },
#     {
#         "text": "Citations with Citation Style Language",
#         "link": "https://citationstyles.org/",
#         "external": True
#     },
#     {
#         "text": "Editing with ProseMirror",
#         "link": "https://prosemirror.net/",
#         "external": True
#     }
# ]


INSTALLED_APPS = [
    # If you want to enable one or several of the social network login options
    # below, make sure you add the authorization keys at:
    # http://SERVER.COM/admin/socialaccount/socialapp/
    # 'allauth.socialaccount.providers.facebook',
    # 'allauth.socialaccount.providers.google',
    # 'allauth.socialaccount.providers.twitter',
    # 'allauth.socialaccount.providers.github',
    # 'allauth.socialaccount.providers.linkedin',
    # 'allauth.socialaccount.providers.openid',
    # 'allauth.socialaccount.providers.persona',
    # 'allauth.socialaccount.providers.soundcloud',
    # 'allauth.socialaccount.providers.stackexchange',
    # "devel",
    "user_template_manager",
]

# A list of apps to remove from the default installation
# This is useful for disabling features you don't need
REMOVED_APPS = [
    # Example: Disable two-factor authentication entirely
    # 'django_otp',
    # Example: Disable brute-force protection (for development only)
    # 'axes',
]

# A list of allowed hostnames of this Fidus Writer installation
ALLOWED_HOSTS = [
    "localhost",
    "127.0.0.1",
]

# Disable service worker (default is True)
# USE_SERVICE_WORKER = False

# The maximum size of user uploaded images in bytes. If you use NGINX, note
# that also it needs to support at least this size.
MEDIA_MAX_SIZE = False

# Create URLs in https (required for social media login)
# ACCOUNT_DEFAULT_HTTP_PROTOCOL = 'https'

# Which domains served over http to allow post requests from. Should be the same as ALLOWED_HOSTS
# But including https://, for example "https://www.domain.com".
# CSRF_TRUSTED_ORIGINS = []

# Add branding logo inside of "static-libs" folder. For example: static-libs/svg/logo.svg
# BRANDING_LOGO = "svg/logo.svg"

# E2EE_MODE controls whether end-to-end encrypted documents are allowed.
# EXPERIMENTAL: E2EE_MODE is an experimental mode that is still subject to changes
# and that has not been independently reviewed by security experts yet.
#
# 'disabled'  - No E2EE support. All documents are unencrypted.
# 'enabled'   - Both E2EE and non-encrypted documents are supported. EXPERIMENTAL
# 'required'  - Only E2EE documents are allowed. EXPERIMENTAL
E2EE_MODE = "disabled"  # Default: disabled for backward compatibility

# EDITOR_SAVE_MODE controls how the editor persists document changes.
#   "collaborative" - WebSocket-based real-time collaboration (default).
#   "direct"        - Periodic REST saves without real-time collaboration.
#   "external"      - No built-in saving; external plugins handle persistence.
# EDITOR_SAVE_MODE = "direct"

#############################################
# Security Settings                         #
#############################################

# IMPORTANT: For production environments, configure these security settings!

# Enable HTTPS security (required for production)
# SECURE_SSL_REDIRECT = True
# SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
# SESSION_COOKIE_SECURE = True
# CSRF_COOKIE_SECURE = True

# HSTS (HTTP Strict Transport Security) - forces HTTPS for your domain
# Only enable this after you're sure HTTPS works correctly!
# SECURE_HSTS_SECONDS = 31536000  # 1 year
# SECURE_HSTS_INCLUDE_SUBDOMAINS = True
# SECURE_HSTS_PRELOAD = True

#############################################
# django-axes: Brute-Force Protection      #
#############################################

# django-axes is configured by default with secure settings.
# Customize these if needed:

# Number of failed login attempts before lockout (default: 5)
# AXES_FAILURE_LIMIT = 5

# Lockout duration in hours (default: 1)
# AXES_COOLOFF_TIME = 1

# Lock out parameters by (default: [["ip_address", "user_agent", "username"]])
# AXES_LOCKOUT_PARAMETERS = [["ip_address", "user_agent", "username"]]

# Reset failed attempts after successful login (default: True)
# AXES_RESET_ON_SUCCESS = True

# For deployments behind a proxy/load balancer, ensure IP detection is correct:
# AXES_IPWARE_META_PRECEDENCE_ORDER = [
#     'HTTP_X_FORWARDED_FOR',
#     'REMOTE_ADDR',
# ]

#############################################
# Password Reset Security                   #
#############################################

# Password reset link timeout in seconds
# Default is 24 hours (86400 seconds) for security reasons
# Django's default is 3 days (259200 seconds)
# Recommended: Keep at 24 hours or less for better security
# PASSWORD_RESET_TIMEOUT = 86400  # 24 hours
# PASSWORD_RESET_TIMEOUT = 43200  # 12 hours (more secure)
# PASSWORD_RESET_TIMEOUT = 3600   # 1 hour (very secure)

#############################################
# GDPR Compliance Settings                 #
#############################################

# For GDPR compliance, ensure you have:
# 1. Privacy Policy and Terms of Service (use FOOTER_LINKS or flatpages)
# 2. Cookie consent mechanism (if using tracking cookies)
# 3. Data export functionality for subject access requests
# 4. Data deletion functionality for right to be forgotten
# 5. Contact information for data protection officer (set CONTACT_EMAIL above)

# Session cookie settings (GDPR compliance - user tracking)
# SESSION_COOKIE_AGE = 1209600  # 2 weeks - adjust based on your needs
# SESSION_EXPIRE_AT_BROWSER_CLOSE = False
# SESSION_SAVE_EVERY_REQUEST = False

# Example footer links with privacy policy and terms:
# FOOTER_LINKS = [
#     {
#         "text": "Privacy Policy",
#         "link": "/pages/privacy/"
#     },
#     {
#         "text": "Terms and Conditions",
#         "link": "/pages/terms/"
#     },
#     {
#         "text": "Data Protection",
#         "link": "/pages/data-protection/"
#     }
# ]

# Email settings for GDPR notifications (e.g., data breach notifications)
# Ensure DEFAULT_FROM_EMAIL and SERVER_EMAIL are properly configured above
