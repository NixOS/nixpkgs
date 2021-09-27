/* === This file is part of Calamares - <https://github.com/calamares> ===
 *
 *   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 */

#include "FileKeeper.h"

#include <QDateTime>
#include <QProcess>
#include <QThread>

#include <GlobalStorage.h>
#include <JobQueue.h>

#include <utils/Logger.h>

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
    Q_UNUSED( configurationMap );
}

CALAMARES_PLUGIN_FACTORY_DEFINITION( FileKeeperJobFactory, registerPlugin< FileKeeperJob >(); )
