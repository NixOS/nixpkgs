/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 */

#include "FileKeeper.h"

#include <GlobalStorage.h>
#include <JobQueue.h>
#include <utils/Logger.h>
#include <utils/Variant.h>

#include <QDateTime>
#include <QProcess>
#include <QThread>

FileKeeperJob::FileKeeperJob( QObject* parent )
    : Calamares::CppJob( parent )
{
}


FileKeeperJob::~FileKeeperJob() {}


QString
FileKeeperJob::prettyName() const
{
    return tr( "File keeper Job" );
}

Calamares::JobResult
FileKeeperJob::exec()
{
    return Calamares::JobResult::ok();
}


void
FileKeeperJob::setConfigurationMap( const QVariantMap& configurationMap )
{
    m_destination
        = CalamaresUtils::getString( configurationMap, "destination", QStringLiteral( "/root/installation" ) );
    m_files = CalamaresUtils::getStringList( configurationMap, "files" );
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( FileKeeperJobFactory, registerPlugin< FileKeeperJob >(); )
